class zulip_internal::zmirror {
  include zulip_internal::base
  include zulip::supervisor

  $zmirror_packages = [# Packages needed to run the mirror
                       "libzephyr4-krb5",
                       "zephyr-clients",
                       "krb5-config",
                       "krb5-user",
                       "krb5-clients",
                       "debathena-kerberos-config",
                       "debathena-zephyr-config",
                       # Packages needed to build pyzephyr
                       "libzephyr-dev",
                       "comerr-dev",
                       "python-dev",
                       "cython",
                       ]
  package { $zmirror_packages: ensure => "installed" }

  file { '/etc/apt/sources.list.d/debathena.list':
    ensure     => file,
    mode       => 644,
    owner      => "root",
    group      => "root",
    source     => 'puppet:///modules/zulip_internal/debathena.list',
  }
  file { "/etc/supervisor/conf.d/zmirror.conf":
    require => Package[supervisor],
    ensure => file,
    owner => "root",
    group => "root",
    mode => 644,
    source => "puppet:///modules/zulip_internal/supervisor/conf.d/zmirror.conf",
    notify => Service["supervisor"],
  }

  file { "/etc/cron.d/zephyr-mirror":
    ensure => file,
    owner  => "root",
    group  => "root",
    mode => 644,
    source => "puppet:///modules/zulip_internal/cron.d/zephyr-mirror",
  }

  file { "/etc/default/zephyr-clients.debathena":
    ensure => file,
    owner  => "root",
    group  => "root",
    mode => 644,
    source => "puppet:///modules/zulip_internal/zephyr-clients.debathena",
  }

  # TODO: Do the rest of our setup, which includes at least:
  # Building python-zephyr after cloning it from https://github.com/ebroder/python-zephyr
  # Putting tabbott/extra's keytab on the system at /home/zulip/tabbott.extra.keytab
}
