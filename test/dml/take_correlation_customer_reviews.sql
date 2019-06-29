-- Do we have a correlation between a book's title's length and its review ratings?
SELECT
    width_bucket(length(product_title), 1, 50, 5) title_length_bucket
    ,round(avg(review_rating), 2) AS review_average
    ,count(*)
FROM
   customer_reviews
WHERE
    product_group = 'Book'
GROUP BY
    title_length_bucket
ORDER BY
    title_length_bucket
;