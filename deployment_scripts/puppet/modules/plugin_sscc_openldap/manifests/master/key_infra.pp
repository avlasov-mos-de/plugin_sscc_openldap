class plugin_sscc_openldap::master::key_infra(
$cacert=undef,
$slapdkey=undef,
$slapdcert=undef,
$master_fqdn=undef,
){

    file {'/etc/ldap/ssl':
      ensure => directory,
      owner => 'root',
      group => 'root',
      mode   => 0755,
    }
    ->
    file {'/etc/ldap/ssl/cacert.pem':
      ensure => file,
      owner => 'openldap',
      group => 'openldap',
      mode   => 0644,
      content => template("plugin_sscc_openldap/cacert.pem.tmpl.erb")
    }
    ->
    file {'/etc/ldap/ssl/slapd_key.pem':
      ensure => file,
      owner => 'openldap',
      group => 'openldap',
      mode   => 0600,
      content => template("plugin_sscc_openldap/slapd_key.pem.tmpl.erb")
    }
    ->
    file {'/etc/ldap/ssl/slapd_cert.pem':
      ensure => file,
      owner => 'openldap',
      group => 'openldap',
      mode   => 0644,
      content => template("plugin_sscc_openldap/slapd_cert.pem.tmpl.erb")
    }
    ->
    file {'/usr/local/share/ca-certificates/cacert.crt':
      ensure => file,
      mode   => 0644,
      content => template("plugin_sscc_openldap/cacert.pem.tmpl.erb")
    }
    ~>
    exec { '/usr/sbin/update-ca-certificates': }

}