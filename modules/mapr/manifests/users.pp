
class mapr::users(
	$config = hiera_hash('mapr', undef)
) {
	$username = $config[user]
	$groupname = $config[group]
	$uid = $config[uid]
	$gid = $config[gid]
	
	group { $groupname:
        ensure => 'present',
        gid => $gid,
	}

	user { $username:
		ensure => 'present',
		uid => $uid,
		gid => $gid,
		shell => '/bin/bash',
		home => "/home/$username",
		managehome => 'true',
		allowdupe => 'false',
		password => '1cb72f9aef55cc124844c2c0ce644b5e9cb858d2',
		require => Group["$groupname"],
	}
}