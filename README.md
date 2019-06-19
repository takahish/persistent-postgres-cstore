# postgres-persistence
Docker image and container of PostgreSQL with volume, and extension which implements a columnar store.

## Building image

```
# Cloning this repository.
$ git clone https://github.com/takahish/postgres-persistence.git

$ cd postgres-persistence

# Updating submodules.
$ git submodule update --init --recursive

# Patching to docker-library/postgres/11/Dockerfile.
$ patch -u postgres/lib/postgres/11/Dockerfile < postgres/patch/postgres_11_Dockerfile.patch

# Building postgres-persistence image.
$ sudo docker build -t postgres-persistence:0.1 postgres/lib/postgres/11

# Building postgres-persistnece-cstore image (This image has columner store).
$ sudo docker build -t postgres-persistence-cstore:0.1 postgres
```

## Correction points

- To upload postgres-persistence and postgres-persistence-cstore images to docker hub.
- To write code for manipulating docker container for cross-platform.
    - src/build_imapge.py: build docker images.
    - src/run_container.py: restore container from images and run it.
    - src/commin_container.py commit container to images.
- To write code for test.
    - test/test_build_image.py: test of src/build_image.py.
    - test/run_container.py: test of src/run_container.py.
    - test/commit_container.py: test of src/commit_container.py.
