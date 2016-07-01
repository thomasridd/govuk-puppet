# == Defined Type: govuk_envdir::env_file
#
# Full description of class envdir here.
#
# === Parameters
#
# Document parameters here.
#
# [*key*]
#   The key in key/value pair or dictionary. This also the name of file.
#
# [*value*]
#   The value for the key and also the content of the file.
#
# [*owner*]
#   The user that owns the file.  Typically the iser that will invoke the environment.
#
# [*path*]
#   The directory where the file exists.
#
# === Examples
# All attributes shown in this example are required.
#
#  include govuk_envdir
#
#  govuk_envdir::env_file { 'AWS_ACCESS_KEY' :
#     owner => 'govuk-backup',
#     key   => 'AWS_ACCESS_KEY',
#     value => 'AL385PEWN199SWWWN42N',
#  }
#
# === Authors
#
# Author Name Mikael Allison
#
#
define govuk_envdir::env_file(
  $owner,
  $key,
  $value,
  $path = '/etc/env_dir/env.d'
){

  include govuk_envdir

  file { $key :
    ensure  => file,
    name    => $key,
    path    => "${path}/${key}",
    owner   => $owner,
    group   => $owner,
    content => $value,
    mode    => '0550',
  }

}
