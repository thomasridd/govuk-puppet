# == Class: govuk::node::s_performance_mongo
#
# performance-mongo node - mongo cluster for performance platform
#
class govuk::node::s_performance_mongo inherits govuk::node::s_base {
  include mongodb_legacy::server
  include mongodb_legacy::backup

  collectd::plugin::tcpconn { 'mongo':
    incoming => 27017,
    outgoing => 27017,
  }

  Govuk_mount['/var/lib/mongodb'] -> Class['mongodb_legacy::server']
  Govuk_mount['/var/lib/automongodbbackup'] -> Class['mongodb_legacy::backup']
}
