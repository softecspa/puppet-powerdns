# = define powerdns::supermaster
#
#   This define configures a supermaster for PowerDNS
#   Operations are performed checking $powerdns::backend_type
#
# == Params
#
# [*ip]
#   Ip of the supermaster (Mandatory)
#
# [*nameserver*]
#   Nameserver for domain (Mandatory)
#
# [*account*]
#   Helps to keep track of where a domain comes from (Default: '')
#
# [*ensure*]
#   Control if a supermaster should be present (Default: present)
#
# == Example
#
#  powerdns::supermaster { 'supermaster_fdqn':
#     ip          => '192.168.23.245',
#     nameserver  => 'ns1.domain.tld',
#  }
#
define powerdns::supermaster (
  $ip, 
  $nameserver,
  $account = '',
  $ensure = 'present',
)
{
  case $powerdns::backend_type {
    'mysql': {
      if ($ensure == 'present'){
        exec { "supermaster_mysql_add_${ip}_${nameserver}":
          command => "mysql -h${powerdns::backends::mysql::host} -u${powerdns::backends::mysql::username} -P${powerdns::backends::mysql::port} -p${powerdns::backends::mysql::password} ${powerdns::backends::mysql::dbname} -e \"INSERT INTO supermasters VALUES ('${ip}', '${nameserver}', '${account}')\"",
          onlyif => "test -z \"`mysql -h${powerdns::backends::mysql::host} -u${powerdns::backends::mysql::username} -P${powerdns::backends::mysql::port} -p${powerdns::backends::mysql::password} ${powerdns::backends::mysql::dbname} -e \"SELECT ip from supermasters WHERE ip='${ip}' AND nameserver='${nameserver}' AND account='${account}'\"`\""
        }
      }
      else {
        exec { "supermaster_mysql_remove_${ip}_${nameserver}":
          command => "mysql -h${powerdns::backends::mysql::host} -u${powerdns::backends::mysql::username} -P${powerdns::backends::mysql::port} -p${powerdns::backends::mysql::password} ${powerdns::backends::mysql::dbname} -e \"DELETE FROM supermasters WHERE ip='${ip}' AND nameserver='${nameserver}' AND account='${account}'\"",
          onlyif => "mysql -h${powerdns::backends::mysql::host} -u${powerdns::backends::mysql::username} -P${powerdns::backends::mysql::port} -p${powerdns::backends::mysql::password} ${powerdns::backends::mysql::dbname} -e \"SELECT ip from supermasters WHERE ip='${ip}' AND nameserver='${nameserver}' AND account='${account}'\" | grep 'ip'"
        }
      }
    }

    default: {
      fail("Backend ${powerdns::backend_type} not supported by supermaster")
    }
  }
}
