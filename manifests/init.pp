# == Class: nisclient
#
# This module manages the NIS client
#
# === Parameters
#
# Document parameters here.
#
# service_ensure
# --------------
# ensure attribute for NIS client service
#
# - *Default*: running
#
# domainname
# --------------
# NIS domain name
#
# - *Default*: example.com
#
class nisclient(
  $service_ensure = 'running',
  $domainname     = 'example.com',
) {

  case $::kernel {
    'linux': {
      $service_name = 'ypbind'
      include nisclient::linux
    }
    'solaris': {
      $service_name = 'nis/client'
      include nisclient::solaris
    }
    default: {
      fail("${module_name} is only supported on Linux and Solaris. Not on ${::kernel}")
    }
  }

}
