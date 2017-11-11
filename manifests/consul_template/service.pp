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
  $vault_auth_path = $::hashicorp::consul_template::vault_auth_path ? {
    false   => $vault_auth_method,
    default => $::hashicorp::consul_template::vault_auth_path
  }
  $vault_ssl_cert = $::hashicorp::consul_template::vault_ssl_cert
  $vault_ssl_key = $::hashicorp::consul_template::vault_ssl_key

  if $vault and !$vault_token {
    include ::hashicorp::vault_env
    case $vault_auth_method {
      'aws': { $service_command = "${install_dir}/vault-env -address=${vault_address} -method=${vault_auth_method} -path=${vault_auth_path} -- ${install_dir}/consul-template -config=${config_dir}" }
      'cert': { $service_command = "${install_dir}/vault-env -address=${vault_address} -method=${vault_auth_method} -path=${vault_auth_path} -client-cert=${vault_ssl_cert} -client-key=${vault_ssl_key} -- ${install_dir}/consul-template -config=${config_dir}" }
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
