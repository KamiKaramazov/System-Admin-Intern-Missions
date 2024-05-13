<?php
/**
 * Database connection settings for WordPress.
 */

define( 'DB_NAME', 'wordpress_db' );
define( 'DB_USER', 'wordpress_user' );
define( 'DB_PASSWORD', 'wordpresspassword' );
define( 'DB_HOST', 'localhost' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

/**
 * Authentication Unique Keys and Salts.
 */

define('AUTH_KEY',         wp_salt('AUTH_KEY'));
define('SECURE_AUTH_KEY',  wp_salt('SECURE_AUTH_KEY'));
define('LOGGED_IN_KEY',    wp_salt('LOGGED_IN_KEY'));
define('NONCE_KEY',        wp_salt('NONCE_KEY'));
define('AUTH_SALT',        wp_salt('AUTH_SALT'));
define('SECURE_AUTH_SALT', wp_salt('SECURE_AUTH_SALT'));
define('LOGGED_IN_SALT',   wp_salt('LOGGED_IN_SALT'));
define('NONCE_SALT',       wp_salt('NONCE_SALT'));
?>
