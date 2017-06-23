# ex: syntax=puppet si sw=2 ts=2 et
class hashicorp::consul::service (
  $ensure,
  $enable,
) {
  include ::hashicorp::consul
  $config_dir = $::hashicorp::consul::config_dir

  hashicorp::service { 'consul':
    ensure      => $ensure,
    enable      => $enable,
    provider    => $::hashicorp::defaults::service_provider,
    args        => "agent -config-dir=${config_dir}",
  }
}
