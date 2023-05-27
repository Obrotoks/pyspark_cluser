#!/bin/bash
# Load variables from .env 
set -o allexport;
source .env;
set +o allexport;


# Create Spark Base 
docker build \
        --build-arg jdk_version=${JDK_VERSION} \
        --build-arg hadoop_version=${HAD_VERSION} \
        --build-arg spark_version=${SPA_VERSION} \
        --build-arg shared_wk=${WORK_DIR} \
        -f Dockerfile \
        -t spark-base .;

# Create the envioroment
docker compose up; 
