{{ config(materialized='table') }}

SELECT DISTINCT twitter_username AS src, REGEXP_EXTRACT(text, '@([A-Za-z0-9_]+)(?:[^A-Za-z0-9_]|$)') AS dst
FROM `graph.tweets`
WHERE REGEXP_EXTRACT(text, '@([A-Za-z0-9_]+)(?:[^A-Za-z0-9_]|$)') IS NOT NULL