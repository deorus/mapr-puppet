
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
}