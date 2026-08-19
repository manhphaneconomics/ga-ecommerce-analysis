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
