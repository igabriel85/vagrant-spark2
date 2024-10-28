export CONDA_DIR=/opt/conda
export PATH=$CONDA_DIR/bin:$PATH
export SPARK_HOME=/usr/local/spark
export PATH=$PATH:${SPARK_HOME}/bin
export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.8.2.1-src.zip
jupyter lab --NotebookApp.token='bd2024' --ip=0.0.0.0 --port=8888 --no-browser --notebook-dir='/home/vagrant' &