{{ config(materialized='table') }}

WITH outdegree AS (
    SELECT src
    FROM `dbt_jolivettiauladell.q3`
    GROUP BY src
    ORDER BY COUNT(*) DESC
    LIMIT 1
),
indegree AS (
    SELECT dst
    FROM `dbt_jolivettiauladell.q3`
    GROUP BY dst
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
SELECT indegree.dst AS max_indegree, outdegree.src AS max_outdegree
FROM outdegree, indegree