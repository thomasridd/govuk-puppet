# == Class: collectd::plugin::statsd
#
# Monitor a local statsd instance
#
# === Parameters:
#
# [*port*]
#   Port that statsd is bound to.
#   Default: 8125
#
class collectd::plugin::statsd (
  $port = 8125,
) {
  @collectd::plugin { 'statsd':
    content => template('collectd/etc/collectd/conf.d/statsd.conf.erb'),
  }
}
