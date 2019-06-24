-- Find all reviews a particular customer made on the Dune series in 1998.
SELECT
    customer_id
    ,review_date
    ,review_rating
    ,product_id
FROM
    customer_reviews
WHERE
    customer_id ='A27T7HVDXA3K2A'
    AND product_title LIKE '%Dune%'
    AND review_date >= '1998-01-01'
    AND review_date <= '1998-12-31'
;
