# ex: syntax=puppet si sw=2 ts=2 et
define hashicorp::download (
  $version,
  $target_dir = '/usr/local/bin',
) {
  include '::hashicorp'
  $cachedir = $::hashicorp::cachedir

  case $::kernel {
    'Linux': { $_os = 'linux' }
    'FreeBSD': { $_os ='freebsd' }
    'OpenBSD': { $_os = 'openbsd' }
    'Darwin': { $_os = 'darwin' }
    default: { fail("Unknown kernel ${::kernel}") }
  }

  case $::architecture {
    'amd64', 'x86_64': { $_arch = 'amd64' }
    'i386', 'i486', 'i586', 'x86': { $_arch = '386' }
    'armel', 'armhf', 'armv6l': { $_arch = 'arm' }
    default: { fail("Unknown architecture: ${::architecture}") }
  }

  $zipfile = "${name}_${version}_${_os}_${_arch}.zip"
  $binfile = "${name}_${version}/${name}"

  exec { "download ${name} ${version}":
    command     => "/usr/local/bin/hashicorp-download.sh ${cachedir} ${name} ${version} ${_os} ${_arch}",
    path        => ['/bin', '/usr/bin'],
    creates     => "${cachedir}/${name}_${version}/${name}",
  }

  file { "${target_dir}/${name}-${version}":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => "${cachedir}/${name}_${version}/${name}",
    require => Exec["download ${name} ${version}"],
  }

  file { "${target_dir}/${name}":
    ensure => link,
    target => "${target_dir}/${name}-${version}",
    before => Anchor["hashicorp::install::${name}"],
  }

  anchor { "hashicorp::install::${name}": }
}
