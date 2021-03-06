# == Class: rabbitmq_save_conf
#
# === Author
# Veritas HyperScale CI <DL-VTAS-ENG-SDIO-HyperScale-Opensource@veritas.com>
#
# === Copyright
# Copyright (c) 2017 Veritas Technologies LLC.
#

class veritas_hyperscale::rabbitmq_save_conf (
)inherits veritas_hyperscale
{
  # Add MQ info to the conf
  $amqp_conf_file = '/opt/VRTSofcore/etc/amqp.conf'

  $rabbit_port = hiera('rabbitmq::port', '')
  if $rabbit_port == '' {
    fail("Rabbitmq port not set.")
  }

  $mgmt_ips = hiera('vrts_config_param2', '')
  if $mgmt_ips == '' {
    fail("vrts_config_param2 is not set.")
  } else {
    $ip_array = split($mgmt_ips, ',')
    $ctrl_ip = join($ip_array, ';')
  }

  $rabbit_pass = hiera('vrts_rabbitmq_pass', 'elacsrepyh')

  exec {'dump_rabbitmq_conf':
    path   => '/usr/bin:/usr/sbin:/bin',
    command => "/bin/sed -i \"s|5672|$rabbit_port|g\" $amqp_conf_file && /bin/sed -i \"s|RABBITMQ_USER|hyperscale|g\" $amqp_conf_file && /bin/sed -i \"s|RABBITMQ_PASSWORD|$rabbit_pass|g\" $amqp_conf_file && /bin/sed -i \"s|MGMT_SERVER_IP|$ctrl_ip|g\" $amqp_conf_file",
  }
}
