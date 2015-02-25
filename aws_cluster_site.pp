hiera_include('classes')


node 'ip-10-36-128-103' {
	include mapr
	
	mapr::install { ['webserver']: }
}

