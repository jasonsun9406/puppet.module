class linux_mgmt {
  class { '::realmd':
    domain               => "$::domain",
    domain_join_user     => "$adcomputerjoinaccountname",
    domain_join_password => "$adcomputerjoinaccountpassword",
    manage_sssd_config => true,
    sssd_config        => {
      'sssd' => {
        'domains'             => "$::domain",
        'config_file_version' => '2',
        'services'            => 'nss,pam',
      },
      "domain/${::domain}" => {
        'ad_domain'                      => "$::domain",
        'krb5_realm'                     => "upcase($::domain)",
        'realmd_tags'                    => 'manages-system joined-with-adcli',
        'cache_credentials'              => 'True',
        'id_provider'                    => 'ad',
        'access_provider'                => 'ad',
        'krb5_store_password_if_offline' => 'True',
        'default_shell'                  => '/bin/bash',
        'ldap_id_mapping'                => 'True',
        'fallback_homedir'               => '/home/%u',
        'access_provider' => 'simple',
        'simple_allow_groups' => 'Domain Admins,Server Admins',
        'ldap_sasl_authid' => "$::hostname",
        'sudo_provider' => 'ad',
      },
    }
  }

  sudo::conf { "admin":
      priority => 10,
      content  => "%domain\ Admins ALL=(ALL) NOPASSWD: ALL",
  }

  class { 'timezone':
    timezone => 'America/Vancouver',
  }
}