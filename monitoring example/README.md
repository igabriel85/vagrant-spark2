# Vagrant-Two-VM Setup

This folder contains a 2 VM setup in which all Spark, Dask and Prometheus monitoring components are ready to use once the VMs have been provisioned.

For more details about prometheus please consult:

- [Prometheus](https://prometheus.io/)
- [Spark support](https://databricks.com/session_na20/native-support-of-prometheus-monitoring-in-apache-spark-3-0)
- [Spark Prometheus example](https://dzlab.github.io/data/2020/06/08/monitoring-spark-prometheus/)

### Layout

Both VMs use the `bento/ubuntu-24.04` box. It works on amd64 hosts and on Apple Silicon (arm64) with VirtualBox 7.1+. The software stack matches the single-VM setup in the repository root: Java 17, a Python 3.11 conda env named `spark`, and Apache Spark 4.0.1 with PySpark 4.0.1. The Dask packages (`distributed`, the dashboard, `dask-ml`) are also installed in the `spark` env.

| VM (`vagrant ssh <name>`) | Hostname / IP | Services (systemd) |
|---|---|---|
| `master` | `prometheus` / 192.168.56.10 | `prometheus`, `grafana-server` |
| `slave1` | `node1` / 192.168.56.2 | `spark-master`, `spark-worker`, `dask-scheduler`, `dask-worker`, `jupyter`, `node_exporter`, `redis-server`, `eci@1`, `chaosrqworker@1` |

All compute (Spark, Dask and the notebooks) runs on node1. Prometheus scrapes node1's node_exporter, so the metrics show the workload and any anomalies induced on that node.

### Start

No Vagrant plugins are needed. If the single-VM machine from the repository root is running, halt it first: both use 192.168.56.2 and several of the same host ports.

```
cd "monitoring example"
vagrant up
```

Provisioning takes about 20-30 minutes. The services are managed by systemd, so they start again after `vagrant halt` / `vagrant up` or `vagrant reload`.

### Ports on the host

| URL | Service |
|---|---|
| http://localhost:8897/lab?token=bd_lab_2026 | JupyterLab on node1 (notebook folder is this directory, synced as `/vagrant`) |
| http://localhost:8082 | Spark master UI |
| http://localhost:8083 | Spark worker UI |
| http://localhost:4041 | Spark application UI (while an application is running) |
| http://localhost:18081 | Spark History Server (start it with `start-history-server.sh` on node1) |
| http://localhost:8787 | Dask dashboard |
| http://localhost:9090 | Prometheus |
| http://localhost:3000 | Grafana (default login admin/admin) |
| http://localhost:5001 | Event inducer REST API |

### Using the clusters from a notebook

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.master("spark://node1:7077").appName("demo").getOrCreate()

from dask.distributed import Client
client = Client("tcp://node1:8786")
```

The Spark worker offers 2 GB and the Dask worker is limited to 2 GiB. Both use all 4 cores of node1.

### Event inducer
The provisioning script also installs an anomaly inducer service written in Python. It is based around a REST API. Using this tool we can stress test our applications and create labeled training data of any anomalies we have induced for ML based analysis.

Useful ports:

- Event inducer service REST API is situated on the slave VM at port 5001
- Prometheus monitoring WebUI is on the master machine at port 9090

#### REST API

The REST API documentation can be downloaded from here:

- [REST API documentation](https://github.com/igabriel85/vagrant-spark2/blob/master/monitoring%20example/anomaly-inducer-REST.pdf)