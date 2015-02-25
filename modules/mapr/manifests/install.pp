define mapr::install {
	package { "mapr-$name":
		ensure => "installed",
		require => [Yumrepo['maprtech'], Yumrepo['maprtechecosystem']],
	}

	case $name {
		'zookeeper': {
			service { 'mapr-zookeeper':
				ensure => "running",
				require => Package['mapr-zookeeper']
			}
		}
	}
}