# ex: syntax=puppet si sw=2 ts=2 et
define hashicorp::service (
  $ensure,
  $enable,
  $provider,
  $install_dir,
  $config_dir,
) {
  if $::hashicorp::defaults::service_type {
    create_resources("::hashicorp::service::${::hashicorp::defaults::service_type}", {
      $name => {
        install_dir => $install_dir,
        config_dir  => $config_dir,
      }
    })
  }

  service { $name:
    ensure   => $ensure,
    enable   => $enable,
    provider => $provider,
    require  => Anchor["hashicorp::install::${name}", "hashicorp::config::${name}"],
  }
}
