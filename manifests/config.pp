# @summary Configures Matrix Synapse
#
# Creates the required folders and configuration files for Matrix Synapse.
#
# @example
#   include synapse::config
class synapse::config(
  String  $server_name                                    = $synapse::server_name,
  Integer $listen_port                                    = $synapse::listen_port,
  String  $listen_address                                 = $synapse::listen_address,
  Integer $metrics_port                                   = $synapse::metrics_port,
  String  $database_name                                  = $synapse::database_name,
  Hash    $database_args                                  = $synapse::database_args,
  String  $media_store_path                               = $synapse::media_store_path,
  String  $uploads_path                                   = $synapse::uploads_path,
  String  $macaroon_secret_key                            = $synapse::macaroon_secret_key,
  Hash    $additional_config                              = $synapse::additional_config,
  Boolean $registration_enabled                           = $synapse::registration_enabled,
  String  $registration_secret                            = $synapse::registration_secret,
  Float   $rc_message_per_second                          = $synapse::rc_message_per_second,
  Float   $rc_message_burst_count                         = $synapse::rc_message_burst_count,
  Float   $rc_registration_per_second                     = $synapse::rc_registration_per_second,
  Float   $rc_registration_burst_count                    = $synapse::rc_registration_burst_count,
  Float   $rc_registration_token_validity_per_second      = $synapse::rc_registration_token_validity_per_second,
  Float   $rc_registration_token_validity_burst_count     = $synapse::rc_registration_token_validity_burst_count,
  Float   $rc_login_address_per_second                    = $synapse::rc_login_address_per_second,
  Float   $rc_login_address_burst_count                   = $synapse::rc_login_address_burst_count,
  Float   $rc_login_account_per_second                    = $synapse::rc_login_account_per_second,
  Float   $rc_login_account_burst_count                   = $synapse::rc_login_account_burst_count,
  Float   $rc_login_failed_attempts_per_second            = $synapse::rc_login_failed_attempts_per_second,
  Float   $rc_login_failed_attempts_burst_count           = $synapse::rc_login_failed_attempts_burst_count,
  Float   $rc_admin_redaction_per_second                  = $synapse::rc_admin_redaction_per_second,
  Float   $rc_admin_redaction_burst_count                 = $synapse::rc_admin_redaction_burst_count,
  Float   $rc_joins_local_per_second                      = $synapse::rc_joins_local_per_second,
  Float   $rc_joins_local_burst_count                     = $synapse::rc_joins_local_burst_count,
  Float   $rc_joins_remote_per_second                     = $synapse::rc_joins_remote_per_second,
  Float   $rc_joins_remote_burst_count                    = $synapse::rc_joins_remote_burst_count,
  Float   $rc_joins_per_room_per_second                   = $synapse::rc_joins_per_room_per_second,
  Float   $rc_joins_per_room_burst_count                  = $synapse::rc_joins_per_room_burst_count,
  Float   $rc_3pid_validation_per_second                  = $synapse::rc_3pid_validation_per_second,
  Float   $rc_3pid_validation_burst_count                 = $synapse::rc_3pid_validation_burst_count,
  Float   $rc_invites_per_room_per_second                 = $synapse::rc_invites_per_room_per_second,
  Float   $rc_invites_per_room_burst_count                = $synapse::rc_invites_per_room_burst_count,
  Float   $rc_invites_per_user_per_second                 = $synapse::rc_invites_per_user_per_second,
  Float   $rc_invites_per_user_burst_count                = $synapse::rc_invites_per_user_burst_count,
  Float   $rc_invites_per_issuer_per_second               = $synapse::rc_invites_per_issuer_per_second,
  Float   $rc_invites_per_issuer_burst_count              = $synapse::rc_invites_per_issuer_burst_count,
  Float   $rc_third_party_invite_per_second               = $synapse::rc_third_party_invite_per_second,
  Float   $rc_third_party_invite_burst_count              = $synapse::rc_third_party_invite_burst_count,
  Float   $rc_federation_window_size                      = $synapse::rc_federation_window_size,
  Float   $rc_federation_sleep_limit                      = $synapse::rc_federation_sleep_limit,
  Float   $rc_federation_sleep_delay                      = $synapse::rc_federation_sleep_delay,
  Float   $rc_federation_reject_limit                     = $synapse::rc_federation_reject_limit,
  Float   $rc_federation_concurrent                       = $synapse::rc_federation_concurrent,
  Float   $federation_rr_transactions_per_room_per_second = $synapse::federation_rr_transactions_per_room_per_second,
) inherits synapse {
  file { $synapse::conf_dir:
    ensure => directory,
    owner  => $synapse::user,
    group  => $synapse::group,
    mode   => '0600',
    notify => Service[$synapse::service_name],
  }

  exec { "Create ${synapse::media_store_path}":
    creates => $synapse::media_store_path,
    command => "mkdir -p ${synapse::media_store_path}",
    path    => $::path
  } -> file { $synapse::media_store_path:
    ensure => directory,
    owner  => $synapse::user,
    group  => $synapse::group,
    mode   => '0644',
    notify => Service[$synapse::service_name],
  }

  exec { "Create ${synapse::uploads_path}":
    creates => $synapse::uploads_path,
    command => "mkdir -p ${synapse::uploads_path}",
    path    => $::path
  } -> file { $synapse::uploads_path:
    ensure => directory,
    owner  => $synapse::user,
    group  => $synapse::group,
    mode   => '0644',
    notify => Service[$synapse::service_name],
  }

  file { $synapse::data_dir:
    ensure => directory,
    owner  => $synapse::user,
    group  => $synapse::group,
    mode   => '0644',
    notify => Service[$synapse::service_name],
  }

  concat { "${synapse::conf_dir}/homeserver.yaml":
    ensure  => present,
    owner   => $synapse::user,
    group   => $synapse::group,
    mode    => '0644',
    require => [File[$synapse::conf_dir], Class['synapse::install']],
    notify  => Service[$synapse::service_name]
  }

  concat::fragment { 'synapse-homeserver':
    target  => "${synapse::conf_dir}/homeserver.yaml",
    content => template('synapse/homeserver.yaml.erb'),
    order   => '01',
  }

  concat::fragment { 'synapse-homeserver-config':
    target  => "${synapse::conf_dir}/homeserver.yaml",
    content => hash2yaml($additional_config)[3, -1],
    order   => '02',
  }

  file { "${synapse::conf_dir}/conf.d/server_name.yaml":
    ensure    => absent,
    subscribe => Package[$synapse::package_name],
  }
}
