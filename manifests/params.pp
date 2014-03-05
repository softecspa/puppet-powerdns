# = class powerdns::params
#
# This class is used to store default values for PowerDNS parameters
#
class powerdns::params {
  $addresses        = ['127.0.0.1']
  $port             = '53'
  $config_dir       = '/etc/powerdns'
  $socket_dir       = '/var/run'
  $daemon           = true
  $guardian         = true
  $uid              = 'pdns'
  $gid              = 'pdns'
  $wildcards        = true
  $master           = false
  $slave            = false
  
  $distributor_threads  = 3
  $receiver_threads     = 1

  $disable_axfr     = true
  $allow_axfr_ips   = []

  $log_level          = 4
  $log_dns_details    = false
  $log_dns_queries    = false
  $log_failed_updates = false
  $query_logging      = false

  $logfile          = false
  $logging_facility = false

  $cache_ttl    = 120
  $query_cache_ttl    = 60
  $max_cache_entries  = 1000000

  $soa_serial_offset    = 0
  $soa_refresh_default  = 10800
  $soa_retry_default    = 3600
  $soa_expire_default   = 604800
  $soa_minimum_ttl      = 3600

  $webserver                 = false
  $webserver_address         = '127.0.0.1'
  $webserver_port            = 5353
  $webserver_password         = 'pdnswebserver'
  $webserver_print_arguments  = false

  $local_config_dir = '/etc/powerdns/pdns.d'

  $service_name = 'pdns'
  $package_name = 'pdns-server'

  $backend_type = 'mysql'

  $service_ensure = running
  $service_enable = true
}