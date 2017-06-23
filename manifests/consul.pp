# ex: syntax=puppet si sw=2 ts=2 et
class hashicorp::consul (
  $version,
  $config_dir         = undef,
  $advertise_addr     = undef,
  $advertise_addr_wan = undef,
  $bind_addr          = undef,
  $bootstrap_expect   = undef,
  $client_addr        = undef,
  $datacenter         = undef,
  $data_dir           = undef,
  $domain             = undef,
  $encrypt            = undef,
  $log_level          = undef,
  $node_name          = undef,
  $raft_protocol      = undef,
  $retry_join         = undef,
  $retry_join_wan     = undef,
  $server             = undef,
  $service            = undef,
  $service_ensure     = undef,
  $service_enable     = undef,
) {
  include ::hashicorp

  hashicorp::download { 'consul':
    version    => $version,
  }

  File {
    ensure => present,
    owner  => $::hashicorp::defaults::config_owner,
    group  => $::hashicorp::defaults::config_group,
    mode   => '0640',
  }

  file { $config_dir:
    ensure => directory,
    mode   => '0755',
  }

  file { "${config_dir}/config.json":
    content => template('hashicorp/consul.conf.erb'),
    before  => Anchor['hashicorp::config::consul'],
    notify  => Service['consul'],
  }

  anchor { 'hashicorp::config::consul': }

  if $service {
    class { 'hashicorp::consul::service':
      ensure      => $service_ensure,
      enable      => $service_enable,
    }
  }
}
