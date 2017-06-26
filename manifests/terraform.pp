# ex: syntax=puppet si sw=2 ts=2 et
class hashicorp::terraform (
  $version,
) {
  hashicorp::download { 'terraform':
    version    => $version,
  }
}
