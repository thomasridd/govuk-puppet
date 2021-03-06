# == Define: govuk_postgresql::monitoring::db
#
# Monitor a postgresql database.
#
define govuk_postgresql::monitoring::db () {
  include govuk_postgresql::monitoring
  @postgresql::server::database_grant { "${title}-nagios-CONNECT":
    privilege => 'CONNECT',
    db        => $title,
    role      => 'nagios',
    tag       => 'govuk_postgresql::server::not_slave',
  }

  @@icinga::check { "check_postgresql_database_connection_${title}_${::hostname}":
    check_command       => "check_nrpe!check_postgresql_database_connection!${title}",
    service_description => "Connection to ${title} postgresql database",
    host_name           => $::fqdn,
  }

}
