{{ config(materialized='table') }}

WITH maga_tweets AS (
    SELECT FORMAT_TIMESTAMP("%Y", PARSE_TIMESTAMP("%a %b %d %T %z %Y", create_time)) AS year, FORMAT_TIMESTAMP("%m", PARSE_TIMESTAMP("%a %b %d %T %z %Y", create_time)) AS month, idx
    FROM `graph.tweets`
    WHERE LOWER(text) LIKE '%maga%'
)
SELECT year, month, COUNT(*) AS count
FROM maga_tweets
GROUP BY year, month
ORDER BY COUNT(*) DESC
LIMIT 5