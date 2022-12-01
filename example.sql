{{ config(materialized='table') }}
Select * from `graph.tweets` limit 10
