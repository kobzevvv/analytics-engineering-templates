{{ config(
    materialized='incremental',
    unique_key='transaction_id'
) }}

WITH base AS (
    SELECT
        transaction_id,
        DATE(TIMESTAMP_MICROS(timestamp)) AS transaction_date
    FROM {{ source('bitcoin_blockchain', 'transactions') }}
    {% if is_incremental() %}
        -- Process only new transactions
        WHERE timestamp > (SELECT MAX(transaction_date) FROM {{ this }})
    {% endif %}
),

daily_summary AS (
    SELECT
        transaction_date,
        COUNT(transaction_id) AS transaction_count
    FROM base
    GROUP BY transaction_date
)

SELECT * FROM daily_summary
