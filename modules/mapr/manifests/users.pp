
class mapr::users(
	$username = hiera('mapr::user', 'mapr'),
	$groupname = hiera('mapr::group', 'mapr'),
	$uid = hiera('mapr::uid', '1000'),
	$gid = hiera('mapr::gid', '1000')
) {
	
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