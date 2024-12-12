## Overview
This model processes Bitcoin blockchain transaction data

## Folder Structure
/project_root
├── conf/
│   ├── .dbt/
│   │   ├── gbq_creds.json       
│   │   └── profiles.yml         
├── data_models/
│   ├── incremental_materialization_use_case/
│   │   ├── blockchain_transactions_by_unique_id.sql
│   ├── sources.yml
├── docker-compose.yml
├── docker-compose-override.yml
├── Dockerfile
├── run_inside_docker.sh

## Load json credentials from a service account with 'BigQuery User' role into conf\.dbt\gbq_creds.json

## Run command
docker-compose up --build

## Overview
This model processes Bitcoin blockchain transaction data and provides a daily summary of transaction counts and total amounts transferred. It uses **incremental materialization** to process only new transactions, optimizing performance and reducing costs.

## Incremental Materialization
- **Trigger condition**: Transactions are processed incrementally based on the `timestamp` field. Only transactions newer than the latest date in the existing table are added.
- **Unique Key**: The `transaction_id` field ensures that transactions are uniquely identified, preventing duplicates in the final table.

## Use Case
This model can be used for:
- **Analytics dashboards** to visualize daily transaction trends.
- **Alert systems** to identify unusual transaction activity.
- **Performance monitoring** to track Bitcoin transaction volumes over time.

## Fields
- `transaction_date`: The date of the transaction.
- `transaction_count`: The total number of transactions on the given day.

## Source
This is defined in data_models\incremental_materilization_use_case\sources.yml