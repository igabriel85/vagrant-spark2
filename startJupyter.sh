#!/usr/bin/env bash

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export SPARK_HOME=/usr/local/spark
export PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:/opt/conda/envs/spark/bin:$PATH

export PYSPARK_PYTHON=/opt/conda/envs/spark/bin/python
export PYSPARK_DRIVER_PYTHON=/opt/conda/envs/spark/bin/python

cd /home/vagrant/work

jupyter lab \
    --ip=0.0.0.0 \
    --port=8888 \
    --no-browser \
    --ServerApp.token="bd_lab_2026"