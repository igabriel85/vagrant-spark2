# Vagrant-Spark2

This repo is the fork of [vagrant-jupyter](https://github.com/giabar/vagrant-jupyter) which is based on Spark 3.1.3 and Jupyter.

This is a Vagrant machine with Jupyter Notebook (v5) installed.
The kernels installed are: Python 3.10.x, Apache Spark 3.1.3 with Scala 2.12.x and PySpark (3.1.3).

The notebook folder is: /home/vagrant.


### Requirements
You have to install:

1. [VirtualBox 5](https://www.virtualbox.org/wiki/Downloads) or later (this Vagrantfile was tested on VirtualBox 7.0.0)
2. VirtualBox Oracle VM VirtualBox Extension Pack
3. [Vagrant](https://www.vagrantup.com)
4. Vagrant plugins [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) to keep updated the guest additions on VM:
```
vagrant plugin install vagrant-vbguest
```
Install Hostmanager plugin
```
vagrant plugin install vagrant-hostmanager
```
Install Disksize plugin
```
vagrant plugin install vagrant-disksize
```

If you'are going to use Vagrant on Windows machine, you could get this error when start a new VM:
```
rsync could not be found on your PATH. Make sure that rsync is properly installed on your system and available on the PATH.
```
In this case you have to install [cwRsync](http://www.rsync.net/resources/howto/windows_rsync.html) and add in your %PATH% the folder where you'll install it:

```
%SystemRoot%\system32;%SystemRoot%;%PROGRAMFILES%\cwRsync_5.4.1_x86_Free; ......
```


### Installation

```
git clone https://github.com/kadnan/vagrant-spark2.git
cd vagrant-spark2
vagrant up
```

When the Vagrant provisioning/start-up processes are completed you can point your browser to:

```
http://localhost:8888
```
> Provisioning will take at least 20minutes!


### If you're behind proxy:

Install [Proxy Configuration Plugin for Vagrant](https://github.com/tmatilai/vagrant-proxyconf/)

### For a two VM Spark monitoring setup you can go to this section of the repository.

