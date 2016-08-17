# == Class: govuk::apps::release::db
#
# Generates database config for rails application
#
# === Parameters:
#
# [*postgresql_release_password*]
#   The password rails will use to authenticate to Postgresql
#   when runnning in a vagrant environment.
#
# [*mysql_release*]
#   The password rails will use to authenticate to Mysql
#   when runnning in a vagrant environment.
#
# [*backend_ip_range*]
#   The ip range/LAN the Postgres database is on.
#
class govuk::apps::release::db (
  $postgresql_release_password = '',
  $mysql_release = '',
  $backend_ip_range   = '10.3.0.0/16',
){

  mysql::db { 'release_production':
    user     => 'release',
    host     => '%',
    password => $mysql_release,
  }

  govuk_postgresql::db {'release_production_postgresql':
    user                    => 'release',
    password                => $postgresql_release_password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
  }
}
