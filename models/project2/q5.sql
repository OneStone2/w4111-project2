{{ config(materialized='table') }}

WITH indegree AS (
    SELECT dst, COUNT(*) AS indegree
    FROM `dbt_jolivettiauladell.q3`
    GROUP BY dst
    UNION ALL
    SELECT DISTINCT src, 0
    FROM `dbt_jolivettiauladell.q3`
    WHERE src NOT IN (
        SELECT dst
        FROM `dbt_jolivettiauladell.q3`
    )
),
avg_likes AS (
    SELECT twitter_username, AVG(like_num) AS avg_likes
    FROM `graph.tweets`
    WHERE twitter_username IN (
        SELECT src
        FROM `dbt_jolivettiauladell.q3`
    )
    GROUP BY twitter_username
    UNION ALL
    SELECT DISTINCT dst, 0
    FROM `dbt_jolivettiauladell.q3`
    WHERE dst NOT IN (
        SELECT src
        FROM `dbt_jolivettiauladell.q3`
    )
),
users AS (
    SELECT A.twitter_username AS username, I.indegree AS indegree, A.avg_likes AS avg_likes
    FROM indegree I, avg_likes A
    WHERE I.dst = A.twitter_username
),
popular_users AS (
    SELECT username
    FROM users
    WHERE indegree >= (
        SELECT AVG(indegree)
        FROM users
    ) AND avg_likes >= (
        SELECT AVG(like_num)
        FROM `graph.tweets`
    )
),
unpopular_users AS (
    SELECT username
    FROM users
    WHERE indegree < (
        SELECT AVG(indegree)
        FROM users
    ) AND avg_likes < (
        SELECT AVG(like_num)
        FROM `graph.tweets`
    )
),
mention AS (
    SELECT twitter_username, REGEXP_EXTRACT(text, '@([A-Za-z0-9_]+)(?:[^A-Za-z0-9_]|$)') AS dst
    FROM `graph.tweets`
    WHERE twitter_username IN (
        SELECT username
        FROM unpopular_users
    ) AND REGEXP_EXTRACT(text, '@([A-Za-z0-9_]+)(?:[^A-Za-z0-9_]|$)') IS NOT NULL
),
mention_popular AS (
    SELECT *
    FROM mention
    WHERE dst IN (
        SELECT username
        FROM popular_users
    )
)
SELECT (1.0*(SELECT COUNT(*) FROM mention_popular)/(SELECT COUNT(*) FROM mention)) AS unpopular_popular