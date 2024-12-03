{%- materialization incremental_custom_order_by_and_parts, adapter='clickhouse' %}
    {%- set ns = namespace() -%}
    {%- set ns.status_message = 'Undefined status' -%}

    {{- __check_placeholder_exists(model, sql, '__DATE__') -}}

    {%- set date_field = config.get('date_field') or 'date' -%}
    {%- set insert_date_field = config.get('insert_date_field') or '__insert_date' -%}

    {%- set initial_history_depth_days = config.require('initial_history_depth_days') -%}
    {%- set date_upper_limit_str = config.get('date_upper_limit') -%}
    {%- set order_by_str = config.get('order_by') -%}
    {%- set partition_by = config.get('partition_by') -%}



    {%- if date_upper_limit_str -%}
        {%- set date_upper_limit = modules.datetime.datetime.strptime(date_upper_limit_str, '%Y-%m-%d').date() -%}
    {%- else -%}
        {%- set date_upper_limit = modules.datetime.date.today() -%}
    {%- endif -%}

    {%- set source_tables = config.require('source_tables') -%}
    {# {{- log('config: ' ~ config ~ '\n', true) -}} #}

    {%- set identifier = model['name'] -%}

    {%- set old_relation = adapter.get_relation(database=database,
                                                schema=schema,
                                                identifier=identifier) -%}

    {%- set target_relation = api.Relation.create(identifier=identifier,
                                                  schema=schema,
                                                  type='table') -%}

    {%- set relation_exists = old_relation is not none -%}
    {{- log('relation_exists: ' ~ relation_exists ~ '\n', true) -}}
    
    {%- if relation_exists and not old_relation.is_table -%}
        {%- set error_message -%}
            Relation '{{ old_relation }}' is not table
        {%- endset -%}
        {{- exceptions.raise_compiler_error(error_message) -}}
    {%- endif -%}

    {%- if relation_exists -%}
        {%- set max_insert_date = 
            __select_aggr_column_value(
                'max',
                target_relation,
                insert_date_field) 
        -%}
        
        {{- log('max_insert_date: ' ~ max_insert_date ~ '\n', true) -}}

        {%- set ns.where -%}
            {# TODO Add config parameter >= or > #}
            {{ insert_date_field }} > '{{ max_insert_date }}'
        {%- endset -%}
    {% else %}
        {%- set ns.where -%}
            {{ date_field }} > date_sub(day, {{ initial_history_depth_days }}, today())
        {%- endset -%}
    {%- endif -%}

    {%- set start_date, end_date = __get_date_range(source_tables,
                                                    date_field,
                                                    date_upper_limit,
                                                    where=ns.where) -%}

    {%- if start_date -%}
        {{- log('Start materialization from ' ~ start_date ~ ' to ' ~ end_date ~ '\n', true) -}}

        {%- if not relation_exists -%}
            {%- set substituted_sql = sql | replace('__DATE__', "'" ~ start_date ~ "'") -%}

            {{- log("\nCreating new target table\n", true) -}}
            {%- call statement('create target table') -%}
                CREATE TABLE {{ target_relation }}
                engine = ReplacingMergeTree({{insert_date_field}})
                PARTITION BY {{ partition_by }}
                ORDER BY ({{ order_by_str }})
                AS (
                    {{ substituted_sql }}
                )
            {%- endcall -%}
        {%- endif -%}
    
        {%- set target_cols = adapter.get_columns_in_relation(target_relation) -%}
        {%- set target_cols_csv = target_cols | map(attribute='quoted') | join(', ') -%}            

        {%- set days_count = (end_date - start_date).days -%}
        {{- log('days_count: ' ~ days_count ~ '\n', true) -}}

        {%- set start_day_offset = 0 if relation_exists else 1 -%}

        {%- for i in range(start_day_offset, days_count + 1) -%}
            {%- set the_date = modules.datetime.timedelta(days=i) + start_date -%}
            {%- set substituted_sql = sql | replace('__DATE__', "'" ~ the_date ~ "'") -%}

            {{- log("\nAppend rows to target: " ~ the_date ~ "\n", true) -}}

          {#  {{- log("\nsubstituted_sql: " ~ substituted_sql ~ "\n", true) -}} #}


            {%- call statement('append rows to target') -%}
                INSERT INTO {{ target_relation }} ( {{ target_cols_csv }} )
                {{ substituted_sql }}
            {%- endcall -%}

        {%- endfor -%}
        {%- set ns.status_message = 'Done' -%}

    {%- else -%}

        {%- set ns.status_message = 'Nothing to do' -%}

    {%- endif -%}

    {{- log('\nFinished. Status: ' ~ ns.status_message ~ '\n', true) -}}
    {%- call noop_statement('main', ns.status_message) -%}
    {%- endcall %}

    {%- do return ({'relations': [target_relation]}) -%}

{%- endmaterialization -%}
