class plugin_sscc_openldap::master::configure (
$master_server_id=undef,
$basedn=undef,
$ldap_user_password=undef,
$ldap_remote_master_fqdn=undef,
){

  package { 'supervisor':
    ensure       => installed,
  }
  ->
  service { 'slapd':
    provider => debian,
    ensure => stopped,
    enable => false,
    hasstatus => true,
    hasrestart => true,
  }
  ->
  exec { '/bin/mv /etc/ldap/slapd.d /etc/ldap/slapd.d.orig':
    creates => '/etc/ldap/slapd.d.orig',
  }
  ->
  file {'/etc/ldap/slapd.d':
    ensure => absent
  }
  ->
  file {'/etc/ldap/slapd.conf':
        owner   => 'openldap',
        group   => 'openldap',
        mode    => '0640',
        content => template("plugin_sscc_openldap/master-slapd.conf.tmpl.erb"),
  }
  ->
  file {"/etc/supervisor/conf.d/slapd-master.conf":
    path    => "/etc/supervisor/conf.d/slapd-master.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("plugin_sscc_openldap/supervisor-slapd-master.tmpl.erb"),
  }
  ~>
  service { 'supervisor':
    provider => debian,
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }


}