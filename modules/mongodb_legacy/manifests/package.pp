# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class mongodb_legacy::package(
  $version,
  $package_name = 'mongodb-10gen',
) {
  include mongodb_legacy::repository

  package { $package_name:
    ensure => $version,
  }
}
