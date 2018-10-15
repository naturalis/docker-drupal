<?php

$databases['default']['default'] = array(
    'database' => '@@database_name@@',
    'username' => '@@database_user@@',
    'password' => '@@database_pass@@',
    'host'     => '@@database_host@@',
    'collation' => 'utf8mb4_general_ci',
    'charset' => 'utf8mb4',
    'port' => '@@database_port@@',
    'driver' => 'mysql',
    'prefix' => '',
);
$update_free_access = FALSE;
$drupal_hash_salt = '@@hash_salt@@';
$base_url = '@@protocol@@://@@base_url@@';

ini_set('session.gc_probability', 1);
ini_set('session.gc_divisor', 100);
ini_set('session.gc_maxlifetime', 200000);
ini_set('session.cookie_lifetime', 2000000);
$cookie_domain = '.@@base_domain@@';
$conf['404_fast_paths_exclude'] = '/\/(?:styles)|(?:system\/files)\//';
$conf['404_fast_paths'] = '/\.(?:txt|png|gif|jpe?g|css|js|ico|swf|flv|cgi|bat|pl|dll|exe|asp)$/i';
$conf['404_fast_html'] = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title>404 Not Found</title></head><body><h1>Not Found</h1><p>The requested URL "@path" was not found on this server.</p></body></html>';
$conf['mail_system']['default-system'] = 'SmtpMailSystem';
$conf['install_profile'] = '@@install_profile@@';

