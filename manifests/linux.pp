# == Class: nisclient::linux
#
class nisclient::linux {

  $domainname = $nisclient::domainname
  $service_ensure = $nisclient::service_ensure
  $service_name = $nisclient::service_name

  case $::osfamily {
    /RedHat|Suse/: {
      $package_name = 'ypbind'
    }
    /Debian/: {
      $package_name = 'nis'
    }
    default: {
      fail("Module ${module_name} is not supported on osfamily <${::osfamily}>")
    }
  }

  package { 'nis_package':
    ensure => installed,
    name   => $package_name,
  }

  file { '/etc/yp.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "domain ${domainname} server 127.0.0.1\n",
    require => Package['nis_package'],
    notify  => Exec['ypdomainname'],
  }

  exec { 'ypdomainname':
    command     => "/bin/ypdomainname ${domainname}",
    refreshonly => true,
    notify      => Service['nis_service'],
  }

  if $::osfamily == 'redhat' {
    exec { 'set_nisdomain':
      path    => '/bin',
      command => "echo NISDOMAIN=${domainname} >> /etc/sysconfig/network",
      unless  => 'grep ^NISDOMAIN /etc/sysconfig/network',
    }

    exec { 'change_nisdomain':
      command => "sed -i 's/^NISDOMAIN.*/NISDOMAIN=${domainname}/' /etc/sysconfig/network",
      path    => '/bin',
      unless  => "grep ^NISDOMAIN=${domainname} /etc/sysconfig/network",
      onlyif  => 'grep ^NISDOMAIN /etc/sysconfig/network',
    }
  }
  elsif $::osfamily =~ /Suse|Debian/ {
    file { '/etc/defaultdomain':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0644,
      content => template('nisclient/defaultdomain.erb'),
    }
  }

  if $::osfamily =~ /RedHat|Suse/ {
    service { 'rpcbind':
      ensure => running,
      enable => true,
      notify => Service['nis_service'],
    }
  }

  if $service_ensure == 'stopped' {
    $service_enable = false
  } else {
    $service_enable = true
  }

  service { 'nis_service':
    ensure => $service_ensure,
    enable => $service_enable,
    name   => $service_name,
  }

}
