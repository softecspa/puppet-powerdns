# = class powerdns
#
# This class install and configures PowerDNS Auth Server
#
# == Params
#
# [*addresses*]
#   List of addresses to bind to. Default ['127.0.0.1']
#
# [*port*]
#   Port to bind to. Default: 53
#
# [*config_dir*]
#   Configuration directory. Default: /etc/powerdns
#
# [*socket_dir*]
#   Socket directory. Default: /var/run
#
# [*daemon*]
#   Start PowerDNS in daemon mode. Default:true
#
# [*guardian*]
#   Run inside a guardian (http://doc.powerdns.com/html/guardian.html). Default: true
#
# [*uid*]
#   Run the process with this user. Default: pdns
#
# [*gid*]
#   Run the process with this group. Default: pdns
#
# [*wildcards*]
#   Honor wildcard records. Default: true
#
# [*master*]
#   Enable master operations. Default: false
#
# [*slave*]
#   Enable slave operations. Defaul: false
#
# [*distributor_threads*]
#   Number of thread for backend. Default: 3
#
# [*receiver_threads*]
#   Number of thread for main process. Default: 1
#
# [*disable_axfr*]
#   Disable teh AXFR protocol. Default: true
#
# [*allow_axfr_ips*]
#   If disable_axfr is false, accept AXFR from these IPs. Default: []
#
# [*log_level*]
#   Log verbosity, in range 0 (less) - 9 (more). Default: 4
#
# [*log_dns_details*]
#   Send informative-only DNS details to log. Default: false
#
# [*log_dns_queries*]
#   Log queries. Default: false
#
# [*log_failed_updates*]
#   Log error during updates. Default: false
#
# [*query_logging*]
#   Instruct backend to log textual representation of query. Default: false
#
# [*logging_facility*]
#   If specified choose which facility use for syslog from the local ones.
#   The vale should be in range 0-7. Default: false
#
# [*cache_ttl*]
#   Seconds to store packets in the Packet Cache: Default: 120
#
# [*query_cache_ttl*]
#   Seconds to store queries with an answer in the Query Cache: Default: 60
#
# [*max_cache_entries*]
#   Number of record in cache: Default: 1000000
#
# [*backend_type*]
#   Specifies which backend is configured, used by supermaster define
#   (Default: mysql)
#
# [*bind_conf_file*]
#   Enable the builtin bindbackend pointing to the conf file (Default: false)
#
# [*bind_check_interval*]
#   If bindbackend is enabled intervalin seconds to reload zone file
#   (Default: 300)
#
# == Require
#   Stdlib: https://forge.puppetlabs.com/puppetlabs/stdlib
#   Softec: https://github.com/softecspa/puppet-softec
#
# == Example
#
#     class { 'powerdns':
#       allow_axfr_ips => ['1.1.1.1', '2.2.2.2'],
#       slave => true,
#     }
#
class powerdns (
  $addresses        = $powerdns::params::addresses,
  $allow_recursion  = $powerdns::params::allow_recursion,
  $port             = $powerdns::params::port,
  $config_dir       = $powerdns::params::config_dir,
  $socket_dir       = $powerdns::params::socket_dir,
  $daemon           = $powerdns::params::daemon,
  $guardian         = $powerdns::params::guardian,
  $uid              = $powerdns::params::uid,
  $gid              = $powerdns::params::gid,
  $wildcards        = $powerdns::params::wildcards,

  $master = $powerdns::params::master,
  $slave  = $powerdns::params::slave,

  $distributor_threads  = $powerdns::params::distributor_threads,
  $receiver_threads     = $powerdns::params::receiver_threads,

  $disable_axfr    = $powerdns::params::disable_axfr,
  $allow_axfr_ips  = $powerdns::params::allow_axfr_ips,

  $log_level          = $powerdns::params::log_level,
  $log_dns_details    = $powerdns::params::log_dns_details,
  $log_dns_queries    = $powerdns::params::log_dns_queries,
  $log_failed_updates = $powerdns::params::log_failed_updates,
  $query_logging      = $powerdns::params::query_logging,
  $logging_facility   = $powerdns::params::logging_facility,

  $cache_ttl          = $powerdns::params::cache_ttl,
  $query_cache_ttl    = $powerdns::params::query_cache_ttl,
  $max_cache_entries  = $powerdns::params::max_cache_entries,

  $soa_serial_offset   = $powerdns::params::soa_serial_offset,
  $soa_refresh_default = $powerdns::params::soa_refresh_default,
  $soa_retry_default   = $powerdns::params::soa_retry_default,
  $soa_expire_default  = $powerdns::params::soa_expire_default,
  $soa_minimum_ttl     = $powerdns::params::soa_minimum_ttl,

  $webserver          = $powerdns::params::webserver,
  $webserver_address  = $powerdns::params::webserver_address,
  $webserver_port     = $powerdns::params::webserver_port,
  $webserver_password = $powerdns::params::webserver_password,

  $webserver_print_arguments = $powerdns::params::webserver_print_arguments,

  $local_config_dir = $powerdns::params::local_config_dir,

  $backend_type = $powerdns::params::backend_type,

  $bind_conf_file = $powerdns::params::bind_conf_file,
  $bind_check_interval = $powerdns::params::bind_check_interval,

  $service_ensure = $powerdns::params::service_ensure,
  $service_enable = $powerdns::params::service_enable,

  $recursor               = $powerdns::params::recursor,
  $recursor_allow_from    = $powerdns::params::recursor_allow_from,
  $recursor_local_address = $powerdns::params::recursor_local_address,
  $recursor_dont_query    = $powerdns::params::recursor_dont_query,
  $recursor_setgid        = $powerdns::params::recursor_setgid,
  $recursor_setuid        = $powerdns::params::recursor_setuid,
  $recursor_forward_zones = [],

) inherits powerdns::params {

  if $::operatingsystem != 'Ubuntu' {
    fail('This module supports only Ubuntu')
  }

  if $::lsbdistrelease != '14.04' {
    fail('This module supports only Ubuntu 14.04')
  }

  if ! defined(Service['rsyslog']) {
    include rsyslog
  }

  $service_name = $powerdns::params::service_name

  $real_daemon       = bool2polarity($daemon)
  $real_guardian     = bool2polarity($guardian)
  $real_wildcards    = bool2polarity($wildcards)
  $real_master       = bool2polarity($master)
  $real_slave        = bool2polarity($slave)

  if ! is_integer($distributor_threads) {
    fail('distributor-threads should be integer')
  }

  if ! is_integer($receiver_threads) {
    fail('receiver-threads should be integer')
  }

  $real_disable_axfr = bool2polarity($disable_axfr)

  if ! is_integer($log_level) or $log_level > 9 or $log_level < 0 {
    fail('loglevel must be integer between 0-9')
  }

  $real_log_dns_details     = bool2polarity($log_dns_details)
  $real_log_dns_queries     = bool2polarity($log_dns_queries)
  $real_log_failed_updates  = bool2polarity($log_failed_updates)
  $real_query_logging       = bool2polarity($query_logging)

  if ! is_integer($query_cache_ttl) {
    fail('query-cache-ttl should be integer')
  }

  if ! is_integer($max_cache_entries) {
    fail('max-cache-entries should be integer')
  }

  $real_webserver     = bool2polarity($webserver)
  $real_webserver_pa  = bool2polarity($webserver_print_arguments)

  validate_bool($recursor)
  validate_array($recursor_allow_from)
  validate_array($recursor_local_address)
  validate_string($recursor_dont_query)
  validate_string($recursor_setgid)
  validate_string($recursor_setuid)
  validate_array($recursor_forward_zones)

  package { $powerdns::params::package_name :
    ensure => present,
  }

  service { $powerdns::params::service_name :
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasrestart => true,
    hasstatus  => true,
  }

  exec { "${powerdns::params::service_name} reload":
    command     => "/etc/init.d/${powerdns::params::service_name} reload",
    refreshonly => true,
  }

  file { '/etc/powerdns/pdns.conf' :
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package[$powerdns::params::package_name],
    content => template('powerdns/pdns.conf.erb'),
    notify  => Service[$powerdns::params::service_name]
  }

  file { '/etc/rsyslog.d/pdns_auth.conf' :
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package['rsyslog'],
    source  => 'puppet:///modules/powerdns/rsyslog_auth.conf',
    notify  => Service['rsyslog']
  }

  file { '/etc/logrotate.d/pdns_auth' :
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/powerdns/logrotate_auth.conf',
  }

  if ($recursor) {
    package { $powerdns::params::recursor_package_name :
      ensure => present,
    }

    service { $powerdns::params::recursor_service_name :
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasrestart => true,
      hasstatus  => false,
    }

    exec { "${powerdns::params::recursor_service_name} restart":
      command     => "service ${powerdns::params::recursor_service_name} restart",
      refreshonly => true,
    }

    file { '/etc/powerdns/recursor.conf' :
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package[$powerdns::params::recursor_package_name],
      content => template('powerdns/recursor.conf.erb'),
      notify  => Service[$powerdns::params::recursor_service_name]
    }
  }

}
