# == Class: govuk::apps::railsgoat
#
# Securitay!
#
# === Parameters
#
# [*port*]
#   The port that railsgoat is served on.
#   Default: 14000
#
class govuk::apps::railsgoat(
  $port = '14000',
) {
  $app_name = 'railsgoat'

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
  }
}
