# == Class: statsd
#
# This class installs and sets-up statsd
#
class statsd() {
  # FIXME Remove this class once deployed

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
