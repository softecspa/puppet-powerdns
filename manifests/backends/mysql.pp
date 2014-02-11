# == define powerdns::backend::mysql
#
# Install and configure mysql backend for PowerDNS
#
# === Params
#
# [*host*]
#   MySQL Host
#
# [*dbname*]
#   MySQL DB name
#
# [*username*]
#   MySQL user
#
# [*password*]
#   MySQL password
#
# [*port*]
#   MySQL port
#
# [*dnssec*]
#   Enable DNSSEC (Default: false)
#
# === Examples
#
define powerdns::backends::mysql (
  $host,
  $dbname,
  $user,
  $password,
  $port=3306,
  $dnssec=false,
)
{
  $real_dnssec = bool2polarity($dnssec)

  package {'pdns-backend-mysql' :
    ensure  => present,
  }

  file { '/etc/powerdns/pdns.d/pdns.local.gmysql' :
    owner   => $powerdns::params::uid,
    group   => 'root',
    mode    => '0640',
    require => Package['pdns-backend-mysql'],
    content => template('powerdns/pdns.local.gmysql.erb'),
    notify  => Service[$powerdns::params::service_name]
  }
}
