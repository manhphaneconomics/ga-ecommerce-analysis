-- =============================================================================
-- Query 02: Bounce rate per traffic source in July 2017
-- Bounce_rate = num_bounce / total_visit
-- Business question: Which traffic sources bring visitors who bounce
-- immediately, and which sources bring more engaged traffic?
-- Result ordered by total_visits DESC.
-- =============================================================================

SELECT
    trafficSource.`source`,
    SUM(totals.visits)   AS total_visits,
    SUM(totals.bounces)  AS total_no_of_bounces,
    ROUND(
        100 * SUM(totals.bounces) / SUM(totals.visits)
    , 3) AS bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
GROUP BY trafficSource.`source`
ORDER BY 2 DESC;
