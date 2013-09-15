Movable Type Prerequisites Cookbook
===================================

This cookbook is used to build a server ready for Movable Type 4 or 5 to be
dropped into the webroot. The result is a LAMP server with the necessary
additional Perl dependencies for Movable Type.

This is tested on Ubuntu only, but may work on other Debian-style distributions.

This was created for use in the development Vagrant-plus-Chef setup, wherein the
Movable Type webroot is in a git repository, and that folder is shared with the
virtual machine's webroot. Thus Movable Type doesn't have to be copied into
place by the cookbook. This suits MT deployments in which the base MT code is
modified, or in which the webroot includes a lot of supplementary PHP or other
code, for example.

Typically you'd include the recipes in this cookbook in a role as follows:

    run_list [
      # Third party, most of which are already marked as dependencies by
      # mt_prereq.
      'recipe[xml]',
      'recipe[mysql]',
      'recipe[mysql::server]',
      'recipe[database]',
      'recipe[database::mysql]',
      'recipe[php]',
      'recipe[php::module_apc]',
      'recipe[apache2]',
      'recipe[apache2::mod_ssl]',
      'recipe[apache2::mod_fcgid]',
      'recipe[apache2::mod_php5]',
      'recipe[perl]',
      'recipe[memcached]',
      # Custom from this cookbook.
      'recipe[mt_prereq]',
      'recipe[mt_prereq::mysql]',
      'recipe[mt_prereq::mysql_import]',
      'recipe[mt_prereq::ssl]'
    ]

With default attributes specified in an environment or role, such as:

    default_attributes(
      :apache => {
         :docroot_dir => '/var/www',
         :cgibin_dir => '/var/www/cgi-bin'
      },
      :mt_prereq => {
        :db => {
          :database => 'example',
          :password => 'password',
          :user => 'example',
          :default_character_set => 'latin1'
        },
        :mt_config => {
          :admin_cgi_path => 'https://www.example.com/cgi-bin/mt/',
          :cgi_path => 'https://www.example.com/cgi-bin/mt/',
          :static_web_path => '/mt-static/',
          :db_object_driver => 'DBI::mysql',
          :db_host => 'localhost',
          :use_memcached => 'true',
          :memcached_namespace => 'example',
          :memcached_servers => '127.0.0.1:11211',
          :optimize_admin_homepage => 'true',
          # Send mail to log.
          :mail_transfer => 'smtp'
          :smtp_server => 'mail.example.com:25'
        },
        :mysql_import => {
          # If a mysqldump file, and the Movable Type database scheme use the
          # default latin1 encoding, it must have been exported with latin1 as
          # the default character set:
          #
          # mysqldump -uroot -p --default-character-set=latin1 database_name > file.sql
          #
          # Otherwise there will be encoding issues.
          :file_path => '/path/to/mysqldump.sql'
        },
        :perl => {
          :memcached_driver => 'Cache::Memcached::Fast'
        },
        :server => {
          :hostname => 'www.example.com',
          :aliases => ['example.com']
        },
        # These defaults indicate to use the snakeoil cert and not perform any
        # copying of certs.
        :ssl => {
          # Destinations.
          :certificate_path => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
          :key_path => '/etc/ssl/private/ssl-cert-snakeoil.key',
          :chain_path => '',
          # Sources.
          :certificate_source_path => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
          :key_source_path => '/etc/ssl/private/ssl-cert-snakeoil.key',
          :chain_source_path => ''
        }
      },
      :mysql => {
        :server_root_password => 'password',
        :server_debian_password => 'password',
        :server_repl_password => 'password'
      }
    )

Recipe: default
---------------

The default recipe configures Apache2, PHP, Perl and Memcached.

It requires these attributes for the server and Apache2 setup:

  * `node['mt_prereq']['server']['hostname']`
  * `node['mt_prereq']['server']['aliases']`

Further attributes with default settings:

  * `node['mt_prereq']['perl']['memcached_driver']`

Attributes from dependent cookbooks that must be set:

  * `node['apache']['docroot_dir']`
  * `node['apache']['cgibin_dir']`

Attributes from dependent cookbooks that probably should be set, especially for
a production environment:

  * Many of the other Apache2 cookbook attributes.

Recipe: mt_config
-----------------

This recipe copies a Movable Type configuration file into place.

Additional attributes required:

  * `node['mt_prereq']['mt_config']['admin_cgi_path']`
  * `node['mt_prereq']['mt_config']['cgi_path']`
  * `node['mt_prereq']['mt_config']['static_web_path']`

Mail related attributes:

  * `node['mt_prereq']['mt_config']['mail_transfer']`
  * `node['mt_prereq']['mt_config']['sendmail_path']`
  * `node['mt_prereq']['mt_config']['smtp_server']`

Attributes with defaults appropriate to a standard LAMP configuration:

  * `node['mt_prereq']['mt_config']['db_object_driver']`
  * `node['mt_prereq']['mt_config']['db_host']`
  * `node['mt_prereq']['mt_config']['use_memcached']`
  * `node['mt_prereq']['mt_config']['memcached_namespace']`
  * `node['mt_prereq']['mt_config']['memcached_servers']`
  * `node['mt_prereq']['mt_config']['optimize_admin_homepage']`

Recipe: mysql
-------------

This recipe configures a MySQL database for use.

It requires the following attributes for the MySQL database setup:

  * `node['mt_prereq']['db']['database']`
  * `node['mt_prereq']['db']['password']`
  * `node['mt_prereq']['db']['user']`
  * `node['mt_prereq']['db']['default_character_set']`

Note that the character set is important: it's very possible that your Movable
Type installation has a latin1 default character set on its database and tables.
It'll be pushing utf8 data into those latin1 tables, which works, but creates
all sorts of annoyances on import / export. The database created here has to
match that default character set for the mysql_import recipe to work without
munging utf8 characters.

Attributes from dependent cookbooks that must be set:

  * `node['mysql']['server_root_password']`
  * `node['mysql']['server_debian_password']`
  * `node['mysql']['server_repl_password']`

Recipe: mysql_import
--------------------

Imports a mysqldump backup of a site database or other SQL into the database
connection specified for the default recipe.

Additional attributes required:

  * `node['mt_prereq']['mysql_import']['file_path']`

Note that there are interesting character encoding issues with Movable Type, as
by default it may be storing utf8 data into latin1 tables in a latin1 database.
Unless you have changed your installation to use utf8 schema, then your export
and import should run this way to avoid encoding problems:

    mysqldump -uroot -p --default-character-set=latin1 db_name > file.sql
    mysql -uroot -p db_name < file.sql

Recipe: ssl
-----------

The SSL recipe installs and configures mod_ssl, with either a snakeoil
self-signed certificate, or a provided certificate.

The following additional attributes determine where the certificate files are
sourced, and where they are copied to in the server. If all of the attributes
are omitted, the server will default to using a self-signed certificate.

  * `node['mt_prereq']['ssl']['certificate_source_path']`
  * `node['mt_prereq']['ssl']['key_source_path']`
  * `node['mt_prereq']['ssl']['chain_source_path']`

  * `node['mt_prereq']['ssl']['certificate_path']`
  * `node['mt_prereq']['ssl']['key_path']`
  * `node['mt_prereq']['ssl']['chain_path']`
