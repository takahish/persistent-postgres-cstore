# persistent-postgres-cstore

Docker image and container of PostgreSQL with volume to persist data. Persitent data aim to inclease research reproductivity. In particular, using the docker image in some research, a researcher can access raw and preprocessed data that is used another researcher, so reserach reproductivity will increase in the project.

In addition, data that is used in research is large, so postgres is extended to columner store that is implemented by [Citus Data](#https://github.com/citusdata/cstore_fdw).

## Build image

```sh
# Clone this repository.
$ git clone https://github.com/takahish/persistent-postgres-cstore.git

$ cd persistent-postgres-cstore

# Update submodules.
$ git submodule update --init --recursive

# Patch to docker-library/postgres/11/Dockerfile.
$ patch -u postgres/lib/postgres/11/Dockerfile < postgres/patch/postgres_11_Dockerfile.patch

# Build persistent-postgres image.
$ sudo docker build -t persistent-postgres:0.1 postgres/lib/postgres/11

# Build postgres-persistnece-cstore image (This image has columner store).
$ sudo docker build -t persistent-postgres-cstore:0.1 postgres
```

## Run container

```sh
# Detach posgres-persistence-cstore.
$ sudo docker run --name dwh -p 5432:5432 -e POSTGRES_USER=dwhuser -d persistent-postgres-cstore:0.1

# Connect persistent-postgres-cstore.
# Prerequisite is to install postgresql for using psql.
$ psql -h localhost -U dwhuser -d dwhuser
psql (10.8 (Ubuntu 10.8-0ubuntu0.18.04.1), server 11.3 (Debian 11.3-1.pgdg90+1))
Type "help" for help.

dwhuser=# \dt
Did not find any relations.

dwhuser=# \q
```

## Load data

```sh
# Download sample data.
$ ./test/data/download_sample.sh

# Difine tables.
$ psql -h localhost -U dwhuser -d dwhuser -f test/ddl/create_customer_reviews.sql
CREATE EXTENSION
CREATE SERVER
CREATE FOREIGN TABLE

# Load sample data.
# Use \copy meta-command.
$ psql -h localhost -U dwhuser -d dwhuser
psql (10.8 (Ubuntu 10.8-0ubuntu0.18.04.1), server 11.3 (Debian 11.3-1.pgdg90+1))
Type "help" for help.

dwhuser=# \copy customer_reviews from '/path/to/persistent-postgres-cstore/customer_reviews_1998.csv' with csv
COPY 589859

dwhuser=# \copy customer_reviews from '/home/takahiro/persistent-postgres-cstore/customer_reviews_1999.csv' with csv
COPY 1172645

dwhuser=# ANALYZE customer_reviews;
ANALYZE

dwhuser=# \q

$ psql -h localhost -U dwhuser -d dwhuser -f test/dml/find_customer_reviews.sql
  customer_id   | review_date | review_rating | product_id
----------------+-------------+---------------+------------
 A27T7HVDXA3K2A | 1998-04-10  |             5 | 0399128964
 A27T7HVDXA3K2A | 1998-04-10  |             5 | 044100590X
 A27T7HVDXA3K2A | 1998-04-10  |             5 | 0441172717
 A27T7HVDXA3K2A | 1998-04-10  |             5 | 0881036366
 A27T7HVDXA3K2A | 1998-04-10  |             5 | 1559949570
(5 rows)

$ psql -h localhost -U dwhuser -d dwhuser -f test/dml/take_correlation_customer_reviews.sql
 title_length_bucket | review_average | count
---------------------+----------------+--------
                   1 |           4.26 | 139034
                   2 |           4.24 | 411318
                   3 |           4.34 | 245671
                   4 |           4.32 | 167361
                   5 |           4.30 | 118422
                   6 |           4.40 | 116412
(6 rows)
```
## Commit container, **Data Persistence**

```sh
# Commit container to image with data
$ sudo docker commit dwh dwh:0.1

# Delete container.
$ sudo docker stop $CONTAINER_ID
$ sudo docker rm $CONTAINER_ID

# Restart container.
$ sudo docker run --name dwh -p 5432:5432 -e POSTGRES_USER=dwhuser -d dwh:0.1

# Check data persistence.
$ psql -h localhost -U dwhuser -d dwhuser -f test/dml/find_customer_reviews.sql
  customer_id   | review_date | review_rating | product_id
----------------+-------------+---------------+------------
 A27T7HVDXA3K2A | 1998-04-10  |             5 | 0399128964
 A27T7HVDXA3K2A | 1998-04-10  |             5 | 044100590X
 A27T7HVDXA3K2A | 1998-04-10  |             5 | 0441172717
 A27T7HVDXA3K2A | 1998-04-10  |             5 | 0881036366
 A27T7HVDXA3K2A | 1998-04-10  |             5 | 1559949570

$ psql -h localhost -U dwhuser -d dwhuser -f test/dml/take_correlation_customer_reviews.sql
 title_length_bucket | review_average | count
---------------------+----------------+--------
                   1 |           4.26 | 139034
                   2 |           4.24 | 411318
                   3 |           4.34 | 245671
                   4 |           4.32 | 167361
                   5 |           4.30 | 118422
                   6 |           4.40 | 116412
(6 rows)
```

## Correction points

- To upload persistent-postgres and persistent-postgres-cstore images to docker hub.
- To write code for manipulating docker container for cross-platform.
    - src/build_imapge.py: build docker images.
    - src/run_container.py: restore container from images and run it.
    - src/commin_container.py commit container to images.
- To write code for test.
    - test/test_build_image.py: test of src/build_image.py.
    - test/run_container.py: test of src/run_container.py.
    - test/commit_container.py: test of src/commit_container.py.
