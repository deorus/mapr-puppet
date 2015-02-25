define mapr::install {
	case $name {
		'zookeeper': { $dontInstall = true }
		'cldb': { $dontInstall = true }
		default: { $dontInstall = false }
	}

	if $dontInstall {
		notify { "To install the Zk and CLDB, please edit the Hiera configuration.": }
	} else {
		package { "mapr-$name":
			ensure => "installed",
			require => [Yumrepo['maprtech'], Yumrepo['maprtechecosystem']],
		}
	}	
}