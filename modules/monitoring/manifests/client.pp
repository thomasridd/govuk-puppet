# == Class: monitoring::client
#
# Configures tools used to monitor localhost and report back to Icinga.
#
# === Parameters
#
# [*standalone_statsd*]
#   If true, use the standalone statsd server
#   If false, use the collectd statsd plugin
#
class monitoring::client (
  $standalone_statsd = true,
){
  validate_bool($standalone_statsd)

  include monitoring::client::apt
  include icinga::client
  include nsca::client
  include auditd
  include collectd
  include collectd::plugin::tcp

  if (!$standalone_statsd) {
    include collectd::plugin::statsd
  }

  package {'gds-nagios-plugins':
    ensure   => '1.4.0',
    provider => 'pip',
    require  => Package['update-notifier-common'],
  }

  class { 'statsd':
    enable => $standalone_statsd,
  }
}
