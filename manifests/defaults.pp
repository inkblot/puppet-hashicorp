# ex: syntax=puppet si sw=2 ts=2 et
class hashicorp::defaults (
  $service_type = undef,
  $systemd_dir = undef,
  $config_owner = undef,
  $config_group = undef,
) {
  case $service_type {
    '::serf::service::upstart': { $service_provider = 'upstart' }
    default: { $service_provider = undef }
  }
}
