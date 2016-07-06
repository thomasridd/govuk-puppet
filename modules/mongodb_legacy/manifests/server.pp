# == Class: mongodb_legacy::server
#
# Setup a MongoDB server.
#
# === Parameters:
#
# [*version*]
# [*package_name*]
# [*dbpath*]
# [*oplog_size*]
#   Defines size of the oplog in megabytes.
#   If undefined, we use MongoDB's default.
#
# [*replicaset_members*]
#   A hash of the members for the replica set.
#   Defaults to empty, which throws an error, so
#   it must be set.
#
# [*development*]
#   Disable journalling and backups and enable query profiling.
#   Saves space at the expense of data integrity.
#   Default: false
#
class mongodb_legacy::server (
  $version,
  $package_name = 'mongodb-10gen',
  $dbpath = '/var/lib/mongodb',
  $oplog_size = undef,
  $replicaset_members = {},
  $development = false,
) {
  validate_bool($development)
  validate_hash($replicaset_members)
  if empty($replicaset_members) {
    fail("Replica set can't have no members")
  }

  unless $development {
    class { 'mongodb_legacy::backup':
      replicaset_members => keys($replicaset_members),
    }
  }

  include govuk_unattended_reboot::mongodb
  include mongodb_legacy::repository

  if $development {
    $replicaset_name = 'development'
  } else {
    $replicaset_name = 'production'
  }

  anchor { 'mongodb_legacy::begin':
    before => Class['mongodb_legacy::repository'],
    notify => Class['mongodb_legacy::service'];
  }


  class { 'mongodb_legacy::package':
    version      => $version,
    package_name => $package_name,
    require      => Class['mongodb_legacy::repository'],
    notify       => Class['mongodb_legacy::service'];
  }

  class { 'mongodb_legacy::config':
    dbpath          => $dbpath,
    development     => $development,
    oplog_size      => $oplog_size,
    replicaset_name => $replicaset_name,
    require         => Class['mongodb_legacy::package'],
    notify          => Class['mongodb_legacy::service'];
  }

  class { 'mongodb_legacy::configure_replica_set':
    replicaset_name   => $replicaset_name,
    members           => $replicaset_members,
    require           => Class['mongodb_legacy::service'];
  }

  class { 'mongodb_legacy::logging':
    require => Class['mongodb_legacy::config'],
  }

  class { 'mongodb_legacy::firewall':
    require => Class['mongodb_legacy::config'],
  }

  class { 'mongodb_legacy::service':
    require => Class['mongodb_legacy::logging'],
  }

  class { 'mongodb_legacy::monitoring':
    dbpath  => $dbpath,
    require => Class['mongodb_legacy::service'],
  }

  class { 'collectd::plugin::mongodb':
    require => Class['mongodb_legacy::config'],
  }

  # We don't need to wait for the monitoring class
  anchor { 'mongodb_legacy::end':
    require => Class[
      'mongodb_legacy::firewall',
      'mongodb_legacy::service',
      'mongodb_legacy::configure_replica_set'
    ],
  }

}
