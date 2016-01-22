# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_procfile {
  file { '/usr/local/bin/govuk_run_procfile_worker':
    ensure => present,
    source => 'puppet:///modules/govuk_procfile/usr/local/bin/govuk_run_procfile_worker',
    mode   => '0755',
  }
}
