name              'mt_prereq'
maintainer        'Reason'
maintainer_email  'reason@exratione.com'
license           'MIT'
description       'Set up a LAMP server ready to support Movable Type 4 or 5. Tested on Ubuntu only.'
version           '0.0.1'
recipe            'mt_prereq', 'Configure the LAMP server packages.'
recipe            'mt_prereq::mysql', 'Configure a MySQL database.'
recipe            'mt_prereq::mysql_import', 'Import SQL into the database.'
recipe            'mt_prereq::ssl', 'Sets up mod_ssl and certificates.'

depends 'apache2'
depends 'apache2'
depends 'apache2'
depends 'database'
depends 'perl'
depends 'php'
depends 'xml'

# Depending on configuration and which recipes are used, also needs these to be
# installed.
# depends 'mysql'
# depends 'memcached'

%w{ ubuntu }.each do |os|
  supports os
end

# Database attributes.

attribute 'mt_prereq/db/database',
  :display_name => 'Database name',
  :description => 'The database name.',
  :default => 'mt'

attribute 'mt_prereq/db/password',
  :display_name => 'Database user password',
  :description => 'The database user password.',
  :default => 'password'

attribute 'mt_prereq/db/user',
  :display_name => 'Database user name',
  :description => 'The database user name.',
  :default => 'mt'

attribute 'mt_prereq/db/default_character_set',
  :display_name => 'Database default character set',
  :description => 'Default character set used in the create database syntax.',
  :default => 'latin1'

# Server attributes.

attribute 'mt_prereq/server/hostname',
  :display_name => 'Server hostname',
  :description => 'The server hostname.',
  :default => 'www.example.com'

attribute 'mt_prereq/server/aliases',
  :display_name => 'Server hostname aliases',
  :description => 'The server hostname aliases.',
  :type => 'array',
  :default => ['example.com']

# Import SQL attributes.

attribute 'mt_prereq/mysql_import/file_path',
  :display_name => 'Import SQL file path',
  :description => 'Absolute path to a SQL path.',
  :default => ''

# MT Config attributes.

attribute 'mt_prereq/mt_config/config_file_path',
  :display_name => 'Path to config file within the cgi-bin directory.',
  :description => 'Path to the Movable Type configuration file within the cgi-bin directory.',
  :default => '/mt/mt-config.cgi'

attribute 'mt_prereq/mt_config/admin_cgi_path',
  :display_name => 'URL or path to the cgi-bin directory for admins.',
  :description => 'URL or path to the cgi-bin directory for admins.'

attribute 'mt_prereq/mt_config/cgi_path',
  :display_name => 'URL or path to the cgi-bin directory for users.',
  :description => 'URL or path to the cgi-bin directory for users.'

attribute 'mt_prereq/mt_config/static_web_path',
  :display_name => 'URL or path to the mt-static directory.',
  :description => 'URL or path to the mt-static directory.'

attribute 'mt_prereq/mt_config/db_object_driver',
  :display_name => 'The object driver configuration value.',
  :description => 'The object driver configuration value.',
  :default => 'DBI::mysql'

attribute 'mt_prereq/mt_config/db_host',
  :display_name => 'The database host.',
  :description => 'Hostname for the database server.',
  :default => 'localhost'

attribute 'mt_prereq/mt_config/use_memcached',
  :display_name => 'Use memcached?',
  :description => 'If true, then use memcached for caching.',
  :default => 'true'

attribute 'mt_prereq/mt_config/memcached_namespace',
  :display_name => 'Memcached namespace.',
  :description => 'Namespace to prefix memcached keys.',
  :default => 'mt'

attribute 'mt_prereq/mt_config/memcached_servers',
  :display_name => 'The memcached servers.',
  :description => 'Space delimited list of memcache host:port designations.',
  :default => '127.0.0.1:11211'

attribute 'mt_prereq/mt_config/optimize_admin_homepage',
  :display_name => 'Optimize admin homepage?',
  :description => 'If true turn off unnecessary features to speed up the admin home page.',
  :default => 'true'

attribute 'mt_prereq/mt_config/mail_transfer',
  :display_name => 'The method of sending mail used.',
  :description => 'The mail transfer method used: smtp | sendmail | debug. The last writes to log.',
  :default => 'debug'

attribute 'mt_prereq/mt_config/smtp_server',
  :display_name => 'The SMTP server to send mail.',
  :description => 'If sending mail via SMTP, this is the server used.'

attribute 'mt_prereq/mt_config/sendmail_path',
  :display_name => 'Path to the sendmail executable.',
  :description => 'If sending mail via sendmail, this is used for the path to the sendmail executable.',
  :default => '/usr/sbin/sendmail'

# Perl attributes.

attribute 'mt_prereq/perl/memcached_driver',
  :display_name => 'Perl module memcached driver.',
  :description => 'Name of the Perl module to use as a memcached driver.',
  :default => 'Cache::Memcached::Fast'

# SSL attributes.

attribute 'mt_prereq/ssl/certificate_source_path',
  :display_name => 'Path to SSL certificate file to be used',
  :description => 'The path to the SSL certificate file that will be copied into place.',
  :default => '/etc/ssl/certs/ssl-cert-snakeoil.pem'

attribute 'mt_prereq/ssl/key_source_path',
  :display_name => 'Path to SSL key file to be used',
  :description => 'The path to the SSL private key file that will be copied into place.',
  :default => '/etc/ssl/private/ssl-cert-snakeoil.key'

attribute 'mt_prereq/ssl/chain_source_path',
  :display_name => 'Path to SSL CA chain file to be used',
  :description => 'The path to the Certificate Authority issued chain file that will be copied into place.',
  :default => ''

attribute 'mt_prereq/ssl/certificate_path',
  :display_name => 'Path to SSL certificate file',
  :description => 'The path to the SSL certificate file.',
  :default => '/etc/ssl/certs/ssl-cert-snakeoil.pem'

attribute 'mt_prereq/ssl/key_path',
  :display_name => 'Path to SSL key file',
  :description => 'The path to the SSL private key file.',
  :default => '/etc/ssl/private/ssl-cert-snakeoil.key'

attribute 'mt_prereq/ssl/chain_path',
  :display_name => 'Path to SSL CA chain file',
  :description => 'The path to the Certificate Authority issued chain file.',
  :default => ''
