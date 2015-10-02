# == Class: govuk::node::s_frontend
#
# Frontend machine definition. Frontend machines run applications
# which serve web pages to users.
#
# === Parameters
#
# [*apps*]
#   An array of which applications should be running on the machine.
#
class govuk::node::s_frontend (
  $apps = [],
) inherits govuk::node::s_base {
  validate_array($apps)

  include govuk::node::s_ruby_app_server

  include $apps

  # FIXME: remove once cleaned up everywhere.
  govuk::app { 'email-campaign-frontend':
    ensure             => absent,
    app_type           => 'rack',
    port               => 3109,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  @@icinga::check::graphite { "check_nginx_connections_writing_${::hostname}":
    target    => "${::fqdn_metrics}.nginx.nginx_connections-writing",
    warning   => 150,
    critical  => 250,
    desc      => 'nginx high conn writing - upstream indicator',
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(nginx-high-conn-writing-upstream-indicator-check),
  }
}
