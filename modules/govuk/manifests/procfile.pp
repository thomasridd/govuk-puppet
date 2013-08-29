class govuk::procfile {
  # One word of caution: this is a generic worker that runs a Rake task,
  # rather than necessarily being tied to the `delayed_job` library.

  file { '/usr/local/bin/govuk_run_procfile_worker':
    ensure  => present,
    source  => 'puppet:///modules/govuk/bin/govuk_run_procfile_worker',
    mode    => '0755',
  }
}
