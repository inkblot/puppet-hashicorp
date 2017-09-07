# ex: syntax=puppet si sw=2 ts=2 et
class hashicorp::consul_template::service (
  $ensure,
  $enable,
) {
  include ::hashicorp::consul_template
  $install_dir = $::hashicorp::install_dir
  $config_dir = $::hashicorp::consul_template::config_dir
  $vault = $::hashicorp::consul_template::vault
  $vault_address = $::hashicorp::consul_template::vault_address
  $vault_token = $::hashicorp::consul_template::vault_token
  $vault_auth_method = $::hashicorp::consul_template::vault_auth_method

  if $vault and !$vault_token {
    include ::hashicorp::vault_env
    case $vault_auth_method {
      'aws': { $service_command = "${install_dir}/vault-env -address=${vault_address} -method=${vault_auth_method} -- ${install_dir}/consul-template -config=${config_dir}" }
      default: { fail("TODO: support vault auth -method=${vault_auth_method}") }
    }
  } else {
    $service_command = "${install_dir}/consul-template -config=${config_dir}"
  }

  hashicorp::service { 'consul-template':
    ensure      => $ensure,
    enable      => $enable,
    provider    => $::hashicorp::defaults::service_provider,
    command     => $service_command,
  }
}
