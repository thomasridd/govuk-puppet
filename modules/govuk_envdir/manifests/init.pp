# == Class: govuk_envdir
#
# Creates a file an directory structure for environment information for use with envdir command.
#
# === Parameters
#
# [*env_root*]
#   Directory that contains env_dir folders
#
# [*env_d*]
#   Directory which contains files with environment content.
#
# === Variables
#
# [*path*]
#   Array of directories to be created
#
# Author Name Mikael Allison
#
#
class govuk_envdir(
  $env_root = '/etc/env_dir',
  $env_d = 'env.d'
){
  $path = [ $env_root,"${env_root}/${env_d}"]

  file { $path :
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0775',
  }

}

