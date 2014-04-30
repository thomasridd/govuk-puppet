class govuk::node::s_frontend_lb {
  include govuk::node::s_base
  include loadbalancer

  $govuk_frontend_servers = extlookup('lb_nodes_frontend')
  $calculators_frontend_servers = extlookup('lb_nodes_calculators_frontend')
  $whitehall_frontend_servers = extlookup('lb_nodes_whitehall_frontend')

  Loadbalancer::Balance {
    https_only    => false, # Varnish/Router can't speak HTTPS.
    internal_only => true,
    servers       => $govuk_frontend_servers,
  }

  $hide_frontend_apps = !str2bool(extlookup('expose_frontend_apps_directly', 'no'))

  loadbalancer::balance {
    [
      'canary-frontend',
      'collections',
      'contacts-frontend',
      'designprinciples',
      'feedback',
      'frontend',
      'hmrc-manuals-frontend',
      'specialist-frontend',
      'limelight',
      'transactions-explorer',
    ]:
      internal_only => $hide_frontend_apps;
    [
      'businesssupportfinder',
      'calculators',
      'calendars',
      'finder-frontend',
      'licencefinder',
      'smartanswers',
      'transaction-wrappers',
      'tariff',
    ]:
      internal_only => $hide_frontend_apps,
      servers       => $calculators_frontend_servers;
    'static':
      internal_only => false;
    'whitehall-frontend':
      internal_only => false,
      servers       => $whitehall_frontend_servers;
  }

  include govuk::apps::publicapi
  include govuk::apps::public_link_tracker

  include performance_platform::spotlight
}
