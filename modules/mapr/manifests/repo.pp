
class mapr::repo ($mapr_release = hiera('mapr::release', '4.0.1')) {

	# TODO check for other kinds of distros
	
	yumrepo { 'maprtech':
		enabled => '1',
		gpgcheck => '0',
		descr => 'MapR Technologies - maprtech',
		baseurl => "http://package.mapr.com/releases/v$mapr_release/redhat/",
		protect => '1',
	}
	
	yumrepo { 'maprtechecosystem':
		enabled => '1',
		gpgcheck => '0',
		descr => 'MapR Technologies - ecosystem',
		baseurl => 'http://package.mapr.com/releases/ecosystem-4.x/redhat',
		protect => '1',
	}	

	yumrepo { 'epel':
		enabled => '1',
		gpgcheck => '0',
		failovermethod => 'priority',
		descr => "Extra Packages for Enterprise Linux 6",
		mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=\$basearch"
	}
}
