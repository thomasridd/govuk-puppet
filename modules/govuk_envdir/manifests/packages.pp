# == Class: govuk_envdir::packages
#
# Required packages for this module.
#
# === Parameters
#
# Document parameters here.
#
# [*packages*]
#   Required packages for this module.
#
# === Authors
#
# Author Name Mikael Allison
#
#
class govuk_envdir::packages {

  $packages = ['daemontools','libc6']


  ensure_packages($packages)

}
