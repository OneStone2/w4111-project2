{{ config(materialized='table') }}

SELECT COUNT(*)/3
FROM `dbt_jolivettiauladell.q3` G1, `dbt_jolivettiauladell.q3` G2, `dbt_jolivettiauladell.q3` G3
WHERE G1.dst = G2.src AND G2.dst = G3.src AND G3.dst = G1.src AND G1.src != G1.dst AND G2.src != G2.dst AND G3.src != G3.dst