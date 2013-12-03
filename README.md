puppet-module-nisclient
=======================

Puppet module to manage a NIS client

[![Build Status](https://travis-ci.org/Ericsson/puppet-module-nisclient.png?branch=master)](https://travis-ci.org/Ericsson/puppet-module-nisclient)

===

# Compatability

This module has been tested to work on the following systems with Puppet v3.

 * EL 5
 * EL 6
 * Suse 11
 * Solaris 10
 * Ubuntu 12.04 LTS

===

# Parameters

domainname
----------
NIS domain name

- *Default*: value of `domain` fact

server
------
NIS server hostname or IP

- *Default*: '127.0.0.1'

package_ensure
--------------
ensure attribute for NIS client package

- *Default*: installed

package_name
------------
name of NIS client package

- *Default*: undef (OS default)

service_ensure
--------------
ensure attribute for NIS client service

- *Default*: running

service_name
------------
name of NIS client service

- *Default*: undef (OS default)
