#!/usr/bin/env bash

set -e


# Configuration
export DEBIAN_FRONTEND=noninteractive

CONDA_DIR=/opt/conda
SPARK_VERSION=4.0.1
SPARK_HOME=/usr/local/spark


# System packages
apt-get update

apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    vim \
    unzip \
    build-essential \
    openjdk-17-jdk-headless

apt-get clean
rm -rf /var/lib/apt/lists/*


# Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

echo "JAVA_HOME=${JAVA_HOME}" >> /etc/environment

echo "Java version:"
java -version


# Miniconda
if [ ! -d "$CONDA_DIR" ]; then

    wget -q \
      https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
      -O /tmp/miniconda.sh

    bash /tmp/miniconda.sh -b -p "$CONDA_DIR"

    rm /tmp/miniconda.sh
fi

export PATH="$CONDA_DIR/bin:$PATH"

echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh

# Accept Anaconda ToS
conda tos accept \
    --override-channels \
    --channel https://repo.anaconda.com/pkgs/main

conda tos accept \
    --override-channels \
    --channel https://repo.anaconda.com/pkgs/r


# Python environment
conda create -y -n spark \
    python=3.11 \
    jupyterlab \
    ipykernel \
    ipywidgets \
    pandas \
    matplotlib \
    scipy \
    scikit-learn \
    pyspark \
    requests


# Apache Spark
echo "Downloading Apache Spark ${SPARK_VERSION}..."

wget -q \
    "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz" \
    -O /tmp/spark.tgz

tar -xzf /tmp/spark.tgz -C /usr/local/

ln -sfn \
    "/usr/local/spark-${SPARK_VERSION}-bin-hadoop3" \
    "$SPARK_HOME"

rm /tmp/spark.tgz


# Spark environment
cat > /etc/profile.d/spark.sh <<EOF
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export SPARK_HOME=/usr/local/spark
export PATH=\$SPARK_HOME/bin:\$SPARK_HOME/sbin:\$PATH
export PYSPARK_PYTHON=/opt/conda/envs/spark/bin/python
export PYSPARK_DRIVER_PYTHON=/opt/conda/envs/spark/bin/python
EOF

# Current provisioning shell
export SPARK_HOME=/usr/local/spark
export PATH="$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH"
export PYSPARK_PYTHON=/opt/conda/envs/spark/bin/python
export PYSPARK_DRIVER_PYTHON=/opt/conda/envs/spark/bin/python


# Additional Python packages
/opt/conda/envs/spark/bin/pip install \
    pyarrow \
    dask \
    pyod \
    pystac-client \
    rasterio


# Jupyter kernel
/opt/conda/envs/spark/bin/python -m ipykernel install \
    --prefix=/opt/conda \
    --name pyspark \
    --display-name "PySpark (Spark 4)"


# Spark event log / History Server
mkdir -p /tmp/spark-events
chmod 1777 /tmp/spark-events

mkdir -p "$SPARK_HOME/conf"

cat > "$SPARK_HOME/conf/spark-defaults.conf" <<EOF
spark.eventLog.enabled            true
spark.eventLog.dir                file:///tmp/spark-events
spark.history.fs.logDirectory     file:///tmp/spark-events
EOF


# Jupyter workspace
mkdir -p /home/vagrant/work
chown -R vagrant:vagrant /home/vagrant/work


# Swappiness
sysctl -w vm.swappiness=10

cat > /etc/sysctl.d/99-spark-lab.conf <<EOF
vm.swappiness=10
EOF


# Permissions
chown -R vagrant:vagrant /opt/conda


# Versions
echo
echo "========================================"
echo "Installation complete"
echo "========================================"

echo "Java:"
java -version

echo
echo "Python:"
/opt/conda/envs/spark/bin/python --version

echo
echo "Spark:"
"$SPARK_HOME/bin/spark-submit" --version

echo
echo "Jupyter:"
/opt/conda/envs/spark/bin/jupyter lab --version

echo "========================================"

#bash script to start Jupyter (in case the logon script doesn't work)
cp /vagrant/startJupyter.sh /home/vagrant/startJupyter.sh
chown vagrant:vagrant /home/vagrant/startJupyter.sh
chmod +x /home/vagrant/startJupyter.sh


echo 'Provisioning complete.'
#start Jupyter at the end of the provisioning
sudo -i -u vagrant /home/vagrant/startJupyter.sh