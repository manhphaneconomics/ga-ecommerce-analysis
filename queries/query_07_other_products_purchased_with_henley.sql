-- =============================================================================
-- Query 07: Other products purchased by customers who also purchased
-- "YouTube Men's Vintage Henley" in July 2017
-- Business question: What else do buyers of this product tend to buy?
-- Useful for cross-sell / bundle recommendations.
-- Output: product name and total quantity ordered.
-- =============================================================================

WITH customer AS (
    SELECT fullVisitorId
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
    UNNEST(hits) hits,
    UNNEST(hits.product) product
    WHERE product.v2ProductName = "YouTube Men's Vintage Henley"
        AND product.productRevenue IS NOT NULL
        AND totals.transactions >= 1
)

SELECT
    product.v2ProductName AS other_purchased_products,
    SUM(product.productQuantity) AS quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
UNNEST(hits) hits,
UNNEST(hits.product) product
WHERE product.productRevenue IS NOT NULL
    AND totals.transactions >= 1
    AND fullVisitorId IN (SELECT fullVisitorId FROM customer)
    AND product.v2ProductName != "YouTube Men's Vintage Henley"
GROUP BY 1
ORDER BY 2 DESC;
