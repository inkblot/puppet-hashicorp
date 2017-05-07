# ex: syntax=puppet sw=2 ts=2 si et
define hashicorp::service::systemd (
  $install_dir,
  $config_dir,
) {
  include ::hashicorp::defaults

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
