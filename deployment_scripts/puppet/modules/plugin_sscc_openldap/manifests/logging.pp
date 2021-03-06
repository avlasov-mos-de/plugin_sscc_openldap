class plugin_sscc_openldap::logging (
  $log_conf = '88-slapd.conf',
) {

  include ::rsyslog::params

  File["${rsyslog::params::rsyslog_d}${log_conf}"] ~> Service["${rsyslog::params::service_name}"]

  file { "${rsyslog::params::rsyslog_d}${log_conf}":
    content => template("plugin_sscc_openldap/rsyslog-slapd.conf.tmpl.erb"),
    owner  => 'syslog',
    group  => 'syslog',
    notify => Service['syslog-service'],
  }
  service { 'syslog-service':
    ensure  => $service_ensure,
    name    => $::rsyslog::params::service_name,
    enable  => $enabled,
  }

}
