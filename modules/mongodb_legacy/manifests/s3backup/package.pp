#
class mongodb_legacy::s3backup::package {

  

  package { 's3cmd' :
    ensure   => present,
    provider => pip,
  }

}
