# == Class: govuk_jenkins::job::tagging_sync_check
#
# Create a file on disk that can be parsed by jenkins-job-builder.
#
# === Parameters
#
# [*app_domain*]
#   The app_domain.
#
# [*publishing_api_bearer_token*]
#   A valid Publishing API bearer token belonging to a API user
#
class govuk_jenkins::job::tagging_sync_check (
  $app_domain = hiera('app_domain'),
  $publishing_api_bearer_token = undef,
) {

  $check_name = 'tagging_sync_check'
  $service_description = 'Tagging migration check'
  $job_url = "https://deploy.${app_domain}/job/tagging-sync-check/"

  file { '/etc/jenkins_jobs/jobs/tagging_sync_check.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/tagging_sync_check.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
