# ex: syntax=puppet si sw=2 ts=2 et
class hashicorp::consul_template (
  $version,
) {
  hashicorp::download { 'consul-template':
    version       => $version,
  }
}
