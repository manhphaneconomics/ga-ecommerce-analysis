SELECT
    *,
    ROUND(100 * num_addtocart / num_product_view, 2) AS add_to_cart_rate,
    ROUND(100 * num_purchase / num_product_view, 2)  AS purchase_rate
FROM (
    SELECT
        FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month,
        COUNTIF(hits.eCommerceAction.action_type = '2') AS num_product_view,
        COUNTIF(hits.eCommerceAction.action_type = '3') AS num_addtocart,
        COUNTIF(hits.eCommerceAction.action_type = '6'
            AND product.productRevenue IS NOT NULL) AS num_purchase
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    UNNEST(hits) hits,
    UNNEST(hits.product) product
    WHERE _table_suffix BETWEEN '0101' AND '0331'
    GROUP BY month
) AS count_out
ORDER BY month;
