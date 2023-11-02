# @summary Installs and configures Matrix Synapse
#
# Installs and configures Matrix Synapse.
#
# @example
#   include synapse
class synapse(
    String  $user = 'matrix-synapse',
    String  $group = 'users',
    Boolean $repo_manage = false,
    Hash    $repo_sources = {},
    Boolean $package_manage = true,
    String  $package_ensure = 'latest',
    String  $package_name = 'matrix-synapse',
    Array[String]
        $package_extras = [],
    String  $server_name = 'example.com',
    Integer $listen_port = 8008,
    String  $listen_address = '127.0.0.1',
    String  $conf_dir = '/etc/matrix-synapse',
    String  $data_dir = '/var/lib/matrix-synapse',
    String  $database_name = 'sqlite3',
    Hash    $database_args = {'database' => "${data_dir}/synapse.db"},
    String  $media_store_path = "${data_dir}/media",
    String  $uploads_path = "${data_dir}/uploads",
    String  $macaroon_secret_key = 'changeme',
    Boolean $service_manage = true,
    String  $service_name = 'matrix-synapse',
    String  $service_ensure = 'running',
    Hash    $additional_config = {},
    Boolean $registration_enabled = false,
    String  $registration_secret = 'changeme',
    Float   $rc_message_per_second = 0.5,
    Float   $rc_message_burst_count = 15.0,
    Float   $rc_registration_per_second = 0.15,
    Float   $rc_registration_burst_count = 2.0,
    Float   $rc_registration_token_validity_per_second = 0.3,
    Float   $rc_registration_token_validity_burst_count = 6.0,
    Float   $rc_login_address_per_second = 0.15,
    Float   $rc_login_address_burst_count = 5.0,
    Float   $rc_login_account_per_second = 0.18,
    Float   $rc_login_account_burst_count = 4.0,
    Float   $rc_login_failed_attempts_per_second = 0.19,
    Float   $rc_login_failed_attempts_burst_count = 7.0,
    Float   $rc_admin_redaction_per_second = 1.0,
    Float   $rc_admin_redaction_burst_count = 50.0,
    Float   $rc_joins_local_per_second = 0.2,
    Float   $rc_joins_local_burst_count = 15.0,
    Float   $rc_joins_remote_per_second = 0.3,
    Float   $rc_joins_remote_burst_count = 12.0,
    Float   $rc_joins_per_room_per_second = 1.0,
    Float   $rc_joins_per_room_burst_count = 10.0,
    Float   $rc_3pid_validation_per_second = 0.003,
    Float   $rc_3pid_validation_burst_count = 5.0,
    Float   $rc_invites_per_room_per_second = 0.5,
    Float   $rc_invites_per_room_burst_count = 5.0,
    Float   $rc_invites_per_user_per_second = 0.004,
    Float   $rc_invites_per_user_burst_count = 3.0,
    Float   $rc_invites_per_issuer_per_second = 0.5,
    Float   $rc_invites_per_issuer_burst_count = 5.0,
    Float   $rc_third_party_invite_per_second = 0.2,
    Float   $rc_third_party_invite_burst_count = 10.0,
    Float   $rc_federation_window_size = 750.0,
    Float   $rc_federation_sleep_limit = 15.0,
    Float   $rc_federation_sleep_delay = 400.0,
    Float   $rc_federation_reject_limit = 40.0,
    Float   $rc_federation_concurrent = 5.0,
    Float   $federation_rr_transactions_per_room_per_second = 40.0,
) {
    include "${module_name}::repo"
    include "${module_name}::install"
    include "${module_name}::config"
    include "${module_name}::service"
}
