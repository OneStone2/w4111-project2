{{ config(materialized='table') }}

WITH users AS (
    SELECT DISTINCT dst AS username
    FROM `dbt_jolivettiauladell.q3`
    UNION DISTINCT
    SELECT DISTINCT src
    FROM `dbt_jolivettiauladell.q3`
),
users_mult AS (
    SELECT username, (SELECT COUNT(*) FROM `dbt_jolivettiauladell.q3` G WHERE username = G.src) AS mult
    FROM users
),
pr0 AS (
    SELECT username, 0 AS iter, 1.0/(SELECT COUNT(*) FROM users) AS weight, mult
    FROM users_mult
),
pr1 AS (
    SELECT G.dst AS username, P.iter+1 AS iter, P.weight/P.mult AS weight, P.mult AS mult
    FROM `dbt_jolivettiauladell.q3` G, pr0 P
    WHERE P.username = G.src
)
SELECT username, SUM(weight) AS page_rank_score
FROM pr1
GROUP BY username
ORDER BY SUM(weight) DESC
LIMIT 20