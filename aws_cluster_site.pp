hiera_include('classes')

node 'ip-10-36-128-103' {
	include mapr
	
	mapr::install { ['zookeeper','fileserver','webserver']: }
}




#
#mapr-cldb
#mapr-zookeeper
#mapr-nfs
#mapr-webserver
#mapr-metrics
#mapr-jobtracker
#mapr-tasktracker
#mapr-resourcemanager
#mapr-nodemanager
#mapr-historyserver
#Package to install
#on client machines that
#run hadoop commands
#mapr-client	mapr-client	mapr-client