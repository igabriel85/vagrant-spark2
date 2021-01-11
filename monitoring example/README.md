# Vagrant-Two-VM Setup

This repository contains a 2 VM setup which is setup in such a way that all Spark and Prometheus monitoring framework components are ready to use once the VMs have been provisioned.

For more details about prometheus please consult:

- [Prometheus](https://prometheus.io/)
- [Spark support](https://databricks.com/session_na20/native-support-of-prometheus-monitoring-in-apache-spark-3-0)
- [Spark Prometheus example](https://dzlab.github.io/data/2020/06/08/monitoring-spark-prometheus/)


### Event inducer
The provisioning script also installs an anomaly inducer service written in Python. It is based around a REST API. Using this tool we can strestest our applications and create labeled training data of any anomalies we have induced for ML based analysis.

Usefull port:

- Event inducer service REST API is situated on the slave VM at port 5001
- Prometheus monitoring WebUI is on the master machine at port 9090

#### REST API

The REST API documentation can be downloaded from here:

- [REST API documentation]()