
class mapr::essentials(
	$config = hiera_hash('mapr', undef)
) {

	define line($file, $line, $ensure = 'present') {
		case $ensure {
			default : { err ( "unknown ensure value ${ensure}" ) }
			present: {
				exec { "/bin/echo '${line}' >> '${file}'":
					unless => "/bin/grep -qFx '${line}' '${file}'"
				}
			}
			absent: {
				exec { "/usr/bin/perl -ni -e 'print unless /^\\Q${line}\\E\$/' '${file}'":
					onlyif => "/bin/grep -qFx '${line}' '${file}'"
				}
			}
		}
	}

	###########################
	# BASE PACKAGES AND CONFS #
	###########################

	include limits
	include system::sysctl
	include system::sysconfig
	
	package { 'java-1.7.0-openjdk-devel':
		ensure => installed
	}

	package { 'sysstat':
		ensure => latest,
	} 
	package { 'clustershell':
		ensure => latest,
	}
	package { 'iftop':
		ensure => latest,
	}
	package { 'iotop':
		ensure => latest,
	}
	package { 'strace':
		ensure => latest,
	}
	package { 'screen':
		ensure => latest,
	}
	package { 'lsof':
		ensure => latest,
	}
	package { 'rsync':
		ensure => latest,
	}

	package { 'mapr-core':
		ensure => "installed",
		require => Yumrepo['maprtech'],
	}

	package { 'mapr-fileserver':
		ensure => "installed",
		require => Yumrepo['maprtech'],
	}


	###################
	# JAVA_HOME SETUP #
	###################

	$java_home_stmt = 'export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64'
	line  { 'set_env_java_home':
		file => '/etc/environment',
    	line => $java_home_stmt,
		require => Package['java-1.7.0-openjdk-devel']
	}

	line  { 'set_mapr_java_home':
		file => '/opt/mapr/conf/env.sh',
    	line => $java_home_stmt,
		require => [Package['java-1.7.0-openjdk-devel'], Package['mapr-core']]
	}


	#######################
	# ZK and CLDB install #
	#######################

    # if hostname is in zookeeper node list, install mapr-zookeeper
    $zkNodes = $config[zk]
    if $zkNodes != "" and inline_template("<%= @zkNodes.include?(@hostname) %>") == "true" {
	    package { 'mapr-zookeeper':
	    	ensure => present,
	    	require => [Package['java-1.7.0-openjdk-devel']]
	    }
    }

    # if hostname is in cldb node list, install mapr-cldb
    $cldbNodes = $config[cldb]
    if $cldbNodes != "" and inline_template("<%= @cldbNodes.include?(@hostname) %>") == "true" {
	    package { 'mapr-cldb':
	    	ensure => present,
	    	require => [Package['java-1.7.0-openjdk-devel']]
	    }
    }

    ##############
    # Disk SETUP #
    ##############
    $disk_setup = $config[disk_setup]
    $disks = $config[disks]


    if $disk_setup and $disks != undef {
    	# write disk list
    	file { '/tmp/disks.txt':
			content => template('mapr/disks.txt.erb'),
			owner   => root,
			group   => root,
			mode    => 644,
    	}

	    exec { 'setup_disks':
			command => "/bin/echo fdx > /tmp/fdx.txt",
			unless => "/opt/mapr/server/mrconfig sp list",
			require => [Package['mapr-fileserver'], File['/tmp/disks.txt']]
		}
    }
}