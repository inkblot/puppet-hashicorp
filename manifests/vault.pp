# ex: syntax=puppet si sw=2 ts=2 et
class hashicorp::vault (
  $version,
) {
  hashicorp::download { 'vault':
    version => $version,
  }
}
