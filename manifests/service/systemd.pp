# ex: syntax=puppet sw=2 ts=2 si et
define hashicorp::service::systemd (
  $command     = false,
  $args,
) {
  include ::hashicorp
  $install_dir = $::hashicorp::install_dir

  $real_command = $command ? {
    false   => "${install_dir}/${name} ${args}",
    default => $command,
  }

  file { "${::hashicorp::defaults::systemd_dir}/${name}.service":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('hashicorp/systemd.service.erb'),
    notify  => Exec["hashicorp::service::${name}::systemd-daemon-reload"],
  }

  exec { "hashicorp::service::${name}::systemd-daemon-reload":
    command     => '/bin/systemctl daemon-reload',
    user        => 'root',
    refreshonly => true,
    before      => Service[$name],
  }
}
