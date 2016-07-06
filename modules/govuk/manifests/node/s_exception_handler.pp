# == Class: govuk::node::s_exception_handler
#
# exception-handler node
#
class govuk::node::s_exception_handler inherits govuk::node::s_base {
  include mongodb_legacy::server
  include govuk::node::s_app_server
  include nginx

  Govuk_mount['/var/lib/mongodb'] -> Class['mongodb_legacy::server']
  Govuk_mount['/var/lib/automongodbbackup'] -> Class['mongodb_legacy::backup']
}
