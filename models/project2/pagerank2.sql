{{ config(materialized='table') }}

WITH RECURSIVE pr AS(
    SELECT username, 0 AS iter, 1.0/(SELECT COUNT(*) FROM (
        SELECT DISTINCT dst AS username
        FROM `dbt_jolivettiauladell.q3`
        UNION DISTINCT
        SELECT DISTINCT src
        FROM `dbt_jolivettiauladell.q3`
    )) AS weight, mult
    FROM (
        SELECT username, (SELECT COUNT(*) FROM `dbt_jolivettiauladell.q3` G WHERE username = G.src) AS mult
        FROM (
            SELECT DISTINCT dst AS username
            FROM `dbt_jolivettiauladell.q3`
            UNION DISTINCT
            SELECT DISTINCT src
            FROM `dbt_jolivettiauladell.q3`
        )
    )
    UNION ALL
    SELECT G.dst AS username, P.iter+1 AS iter, P.weight/P.mult AS weight, P.mult AS mult
    FROM `dbt_jolivettiauladell.q3` G, pr P
    WHERE P.username = G.src AND P.iter < 4
)
SELECT username, SUM(weight) AS page_rank_score
FROM pr
WHERE iter = 4
GROUP BY username
ORDER BY SUM(weight) DESC
LIMIT 20