# == Class: govuk::node::s_performance_backend
#
# Class to define machines that run the Performance Platform backend.
#
class govuk::node::s_performance_backend inherits govuk::node::s_base {
  include nginx
  include nodejs

  include govuk::apps::performanceplatform_notifier
  include govuk::apps::performanceplatform_admin
}
