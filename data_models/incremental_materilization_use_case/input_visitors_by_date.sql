-- This model generates random visitor counts for the last 15 days
WITH date_series AS (
    -- Generate a list of dates for the last 15 days
    SELECT 
        CURRENT_DATE() - INTERVAL day_num DAY AS visit_date
    FROM 
        UNNEST(GENERATE_ARRAY(0, 14)) AS day_num
),
random_visits AS (
    -- Assign a random visitor count to each date
    SELECT 
        visit_date,
        CAST(FLOOR(RAND() * 100) AS INT) AS visitor_count  -- Generates a random number between 0 and 99
    FROM 
        date_series
)
SELECT 
    visit_date,
    visitor_count
FROM 
    random_visits
ORDER BY 
    visit_date