# mapr-puppet

Puppet module to deploy MapR Hadoop distribution.

TODO
====
* Most of the instructions work on CentOS but they weren't tested on other targeted systems such as Ubuntu and SUSE, supported by MapR.

* Assure ntp is installed and running.

* Configure mysql and metrics database.

* Apply license.

* Create default volumes.

* Create 'role' for mapr-client nodes.

* Install OpenTSDB with MapR-DB support.


Setup
=====

1. Setup hostname and /etc/hosts on all the nodes

2. Make sure you have Puppet installed on all the nodes

> rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

> yes | yum -y install puppet

> puppet --version

You should use Puppet 3.x.

Make you sure you have also Git installed, if you want to pull the recipes directly from this repo.

> yum install -y git

3. Clone this git repo with the definitions

> git clone https://github.com/deorus/mapr-puppet.git

4. Adapt the final site puppet cookbook

Adapt global configuration variables in common.yaml or override node specific settings creating an YAML file for the specified node FQDN (e.g. ip-10-36-128-103.eu-west-1.compute.internal.yaml ).


Edit Zookeeper and CLDB list – Zookeeper and CLDB will be installed on the nodes specified in the CLDB and ZK list (see common.yaml).

Specify what you want to install on each node in a puppet file. Please find a sample in aws_cluster_site.pp 

Fileserver will be installed on all the nodes.


5. Run puppet against it:

> puppet apply --modulepath=`pwd`/mapr-puppet/modules --hiera_config=`pwd`/mapr-puppet/hiera.yaml `pwd`/mapr-puppet/aws_cluster_site.pp



Limitations
===========

Currently this recipe doesn't cover multihomed setups.

