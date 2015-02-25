
class mapr::repo (
	$config = hiera_hash('mapr', undef)
) {
	$mapr_release = $config[release]
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

	rpmkey { '66B3F0D6':
		ensure => present,
		source => 'http://package.mapr.com/releases/pub/maprgpg.key',
	}
}
