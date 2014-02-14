# == class powerdns::backend::mysql
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
#   powerdns::backends::mysql{ 'backend01':
#     host=>'localhost',
#     dbname=>'pdns',
#     user=>'someuser',
#     password=>'somepass',
#   }
#
class powerdns::backends::mysql (
  $host,
  $dbname,
  $username,
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
    #notify  => Service[$powerdns::service_name]
  }
}
