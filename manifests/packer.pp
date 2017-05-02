# ex: syntax=puppet si sw=2 ts=2 et
class hashicorp::packer (
  $version,
) {
  hashicorp::download { 'packer':
    version       => $version,
  }
}
