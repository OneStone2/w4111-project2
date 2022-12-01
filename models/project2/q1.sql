{{ config(materialized='table') }}

SELECT id, text 
FROM `graph.tweets`
WHERE LOWER(text) LIKE '%maga%' AND LOWER(text) LIKE '%trump%'