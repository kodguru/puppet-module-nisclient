# == Class: nisclient::solaris
#
class nisclient::solaris {
  
  $domainname = $nisclient::domainname
  $service_ensure = $nisclient::service_ensure
  $service_name = $nisclient::service_name

  file { ["/var/yp", "/var/yp/binding", "/var/yp/binding/${domainname}"]: 
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0644,
  }

  file { "/var/yp/binding/${domainname}/ypservers":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    require => File["/var/yp/binding/${domainname}"],
    notify  => Exec['domainname'],
    content => "localhost\n",
  }

  exec { 'domainname':
    command     => "/usr/bin/domainname ${domainname}",
    refreshonly => true,
    notify      => Service['nis_service'],
  }

  file { '/etc/defaultdomain':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('nisclient/defaultdomain.erb'),
  }

  if $service_ensure == 'stopped' {
    $service_enable = false
  } else {
    $service_enable = true
  }

  service { 'nis_service'
    ensure => $service_ensure,
    enable => $service_enable,
    name   => $service_name,
  }

}
