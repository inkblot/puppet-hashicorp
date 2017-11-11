# ex: syntax=puppet si sw=2 ts=2 et
class hashicorp::consul_template (
  $version,
  $config_dir               = undef,
  $run_dir                  = undef,
  $cache_dir                = undef,
  $consul_auth              = undef,
  $consul_auth_username     = undef,
  $consul_auth_password     = undef,
  $consul_address           = undef,
  $consul_token             = undef,
  $consul_retry             = undef,
  $consul_retry_attempts    = undef,
  $consul_retry_backoff     = undef,
  $consul_retry_max_backoff = undef,
  $consul_ssl               = undef,
  $consul_ssl_verify        = undef,
  $consul_ssl_cert          = undef,
  $consul_ssl_key           = undef,
  $consul_ssl_ca_cert       = undef,
  $consul_ssl_ca_path       = undef,
  $consul_ssl_server_name   = undef,
  $vault                    = undef,
  $vault_address            = undef,
  $vault_auth_method        = undef,
  $vault_auth_path          = undef,
  $vault_token              = undef,
  $vault_grace              = undef,
  $vault_unwrap_token       = undef,
  $vault_renew_token        = undef,
  $vault_retry              = undef,
  $vault_retry_attempts     = undef,
  $vault_retry_backoff      = undef,
  $vault_retry_max_backoff  = undef,
  $vault_ssl                = undef,
  $vault_ssl_verify         = undef,
  $vault_ssl_cert           = undef,
  $vault_ssl_key            = undef,
  $vault_ssl_ca_cert        = undef,
  $vault_ssl_ca_path        = undef,
  $vault_ssl_server_name    = undef,
  $log_level                = undef,
  $service                  = undef,
  $service_ensure           = undef,
  $service_enable           = undef,
) {
  include ::hashicorp
  $install_dir = $::hashicorp::install_dir

  hashicorp::download { 'consul-template':
    version    => $version,
  }

  File {
    ensure => present,
    owner  => $::hashicorp::defaults::config_owner,
    group  => $::hashicorp::defaults::config_group,
    mode   => '0640',
  }

  file { [ $config_dir, $run_dir, $cache_dir ]:
    ensure => directory,
    mode   => '0755',
  }

  $pid_file = "${run_dir}/consul-template.pid"

  file { "${config_dir}/consul-template.conf":
    content => template('hashicorp/consul-template.conf.erb'),
    before  => Anchor['hashicorp::config::consul-template'],
  }

  anchor { 'hashicorp::config::consul-template': }

  if $service {
    class { 'hashicorp::consul_template::service':
      ensure      => $service_ensure,
      enable      => $service_enable,
      subscribe   => File["${config_dir}/consul-template.conf"]
    }

    Hashicorp::Consul_template::Template<||> ~> Service['consul-template']
  }
}
