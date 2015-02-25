

class mapr::setup (
    $config = hiera_hash('mapr', undef)
) {

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


    #############
    # CONFIGURE #
    #############

    $cldbPort = $config[cldb_port]
    $cldbList = inline_template('<%= @cldbNodes.map! { |host| "#{host}:#{@cldbPort}" }.join(",") %>')

    $zkPort = $config[zk_port]
    $zkList = inline_template('<%= @zkNodes.map! { |host| "#{host}:#{@zkPort}" }.join(",") %>')

    $rmHost = $config[rm_host]
    $clusterName = $config[clustername]

    $configure_cmd = "/opt/mapr/server/configure.sh -C $cldbList -Z $zkList -RM $rmHost -N $clusterName -no-autostart"

    ##############
    # Disk SETUP #
    ##############

    $disk_setup = $config[disk_setup]
    $disks = $config[disks]

    if $disk_setup and $disks != undef {
        # write disk list
        file { '/tmp/disks.txt':
            content => template('mapr/disks.txt.erb'),
        }

        $disk_setup_cmd = "$configure_cmd -F /tmp/disks.txt"
        exec { 'setup_disks':
            command => "$disk_setup_cmd",
            unless => "/opt/mapr/server/mrconfig sp list",
            path => "/usr/bin:/bin",
            timeout => 0,
            require => [Package['mapr-fileserver'], File['/tmp/disks.txt']]
        }
    } else {
        # Run configure normally
        exec { 'configure':
            command => "$configure_cmd",
            path => "/usr/bin:/bin",
            timeout => 0,
            require => [Package['mapr-fileserver']]
        }
    }
}