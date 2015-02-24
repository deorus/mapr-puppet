# mapr-puppet

Puppet module to deploy MapR Hadoop distribution.

TODO
====
Most of the instructions work on CentOS but they weren't tested on other targeted systems such as Ubuntu and SUSE, supported by MapR.

Assure ntp is installed and running.

Setup
=====

1. Setup hostname and /etc/hosts on all the nodes

2. Make sure you have Puppet installed on all the nodes

> rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

> yes | yum -y install puppet

> puppet --version

You should use 3.x.

3. Clone this git repo with the definitions

> git clone https://github.com/deorus/mapr-puppet.git

4. Adapt the final site puppet cookbook

Please find a sample in aws_cluster_site.pp 

5. Run puppet against it:

> puppet apply --modulepath=`pwd`/mapr-puppet/modules --hiera_config=`pwd`/mapr-puppet/hiera.yaml `pwd`/mapr-puppet/aws_cluster_site.pp


