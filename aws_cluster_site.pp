hiera_include('classes')


node 'ip-10-36-128-103' {
	include mapr
	
	# packages installed in all the nodes
	mapr::install { ['nfs','metrics','tasktracker','nodemanager']: }

	# packages installed just on some nodes
	mapr::install { ['webserver','jobtracker','resourcemanager','historyserver']: }
	
	include mapr::setup
}

node 'ip-10-39-4-200','ip-10-39-20-157' {
	include mapr
	
	# packages installed in all the nodes
	mapr::install { ['nfs','metrics','tasktracker','nodemanager']: }

	include mapr::setup	
}