# == Class: statsd
#
# This class installs and sets-up statsd
#
# === Parameters
#
# [*enable*]
#   Boolean; determines whether standalone statsd server is installed
#
# [*graphite_hostname*]
#   Hostname of Graphite server
#
class statsd (
  $enable = true,
  $graphite_hostname = undef,
){
  validate_bool($enable)

  if ($enable) {
    include govuk::ppa
    include nodejs

    package { 'statsd':
      ensure  => 'latest',
      require => Class['nodejs'],
    }

    file { '/etc/statsd.conf':
      content => template('statsd/etc/statsd.conf.erb'),
      require => Package['statsd'],
      notify  => Service['statsd'],
    }

    service { 'statsd':
      ensure  => running,
      require => [Package['statsd'], File['/etc/statsd.conf']],
    }

    @@icinga::check { "check_statsd_upstart_up_${::hostname}":
      check_command       => 'check_nrpe!check_upstart_status!statsd',
      service_description => 'statsd upstart up',
      host_name           => $::fqdn,
    }
  } else {
    if (!defined(Class['nodejs'])) {
      class { 'nodejs':
        version => 'absent',
      }
    }

    package { 'statsd':
      ensure  => absent,
    }

    file { '/etc/statsd.conf':
      ensure => absent,
    }

    service { 'statsd':
      ensure => stopped,
      before => [Package['statsd'], File['/etc/statsd.conf']],
    }
  }
}
