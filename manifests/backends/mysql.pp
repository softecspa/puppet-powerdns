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
# [*enable*]
#   Enable Bind built-in support (Default: false)
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
  $dbname='pdns',
  $username='pdns',
  $password=false,
  $port=3306,
  $dnssec=false,
)
{
  $real_dnssec = bool2polarity($dnssec)

  if $powerdns::bind_conf_file {
    $backends = 'gmysql,bind'
  }
  else {
    $backends = 'gmysql'
  }

  package { 'pdns-backend-mysql' :
    ensure  => present,
  }

  file { '/etc/powerdns/pdns.d/pdns.simplebind.conf':
    ensure => absent,
  }

  file { '/etc/powerdns/pdns.d/pdns.local.gmysql.conf' :
    owner   => $powerdns::params::uid,
    group   => 'root',
    mode    => '0640',
    require => [ 
      Package['pdns-backend-mysql'], 
      File['/etc/powerdns/pdns.d/pdns.simplebind.conf'],
    ],
    content => template('powerdns/pdns.local.gmysql.erb'),
    notify  => Service[$powerdns::service_name]
  }
}
