#!/bin/bash

# Download sample data from citus to load cstore.
wget http://examples.citusdata.com/customer_reviews_1998.csv.gz
wget http://examples.citusdata.com/customer_reviews_1999.csv.gz

# Uncompress sample data.
gzip -d customer_reviews_1998.csv.gz
gzip -d customer_reviews_1999.csv.gz
