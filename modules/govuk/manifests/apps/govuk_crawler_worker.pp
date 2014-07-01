class govuk::apps::govuk_crawler_worker (
  $enabled   = false,
  $amqp_pass = 'guest',
  $port = 3074,
) {
  if $enabled {
    Govuk::App::Envvar {
      app => 'govuk_crawler_worker',
    }

    $blacklist_paths = ['/trade-tariff', '/licence-finder',
      '/business-finance-support-finder', '/government/uploads',
      '/apply-for-a-licence', '/search', '/government/announcements.atom',
      '/government/publications.atom']

    govuk::app::envvar {
      'AMQP_ADDRESS':
        value => "amqp://govuk_crawler_worker:${amqp_pass}@rabbitmq-1:5672/govuk_crawler_worker";
      'AMQP_EXCHANGE':
        value => 'govuk_crawler_exchange';
      'AMQP_MESSAGE_QUEUE':
        value => 'govuk_crawler_queue';
      'BLACKLIST_PATHS':
        value => join($blacklist_paths, ',');
      'REDIS_ADDRESS':
        value => 'redis-1:6379';
      'REDIS_KEY_PREFIX':
        value => 'govuk_crawler_worker';
      'ROOT_URL':
        value => 'https://www.gov.uk/';
    }

    govuk::app { 'govuk_crawler_worker':
      app_type => 'bare',
      port     => $port,
      command  => './govuk_crawler_worker',
    }

    govuk::logstream { 'govuk_crawler_worker-error-log':
      logfile => '/var/log/govuk_crawler_worker/default.log',
      tags    => ['error'],
      fields  => {'application' => 'govuk_crawler_worker'},
    }
  }
}