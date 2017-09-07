# ex: syntax=puppet si sw=2 ts=2 et
define hashicorp::consul_template::template (
  $source          = undef,
  $content         = undef,
  $mode            = '0644',
  $command         = undef,
  $command_timeout = undef,
  $min_wait        = undef,
  $max_wait        = undef,
) {
  include ::hashicorp::consul_template

  validate_absolute_path($name)
  $cooked_name = regsubst($name, '/', '__', 'G')
  $cache_dir = $::hashicorp::consul_template::cache_dir
  $config_dir = $::hashicorp::consul_template::config_dir
  
  File {
    owner => 'root',
    group => 'root',
    mode  => '0640',
  }

  file { "${cache_dir}/${cooked_name}":
    ensure  => present,
    source  => $source,
    content => $content,
  }

  file { "${config_dir}/${cooked_name}":
    ensure  => present,
    content => template('hashicorp/consul-template_template.conf.erb'),
  }

  if $::hashicorp::consul_template::service {
    File["${config_dir}/${cooked_name}"] ~> Service['consul-template']
  }
}

