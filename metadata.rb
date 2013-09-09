name              'mt_prereq'
maintainer        'Reason'
maintainer_email  'reason@exratione.com'
license           'MIT'
description       'Set up a LAMP server ready to support Movable Type 4 or 5. Tested on Ubuntu only.'
version           '0.0.1'
recipe            'mt_prereq', 'Sets up the LAMP server and supporting packages, with an empty webroot.'

depends 'apache2'
depends 'database'
depends 'memcached'
depends 'mysql'
depends 'perl'
depends 'php'
depends 'xml'

%w{ ubuntu }.each do |os|
  supports os
end

# Database attributes.

attribute 'mt_prereq/db/database',
  :display_name => 'Database name',
  :description => 'The database name.',
  :default => 'mt'

attribute 'mt_prereq/db/mysqldump_file_path',
  :display_name => 'Mysqldump file path',
  :description => 'Absolute path to a mysql path.',
  :default => ''

attribute 'mt_prereq/db/password',
  :display_name => 'Database user password',
  :description => 'The database user password.',
  :default => 'password'

attribute 'mt_prereq/db/user',
  :display_name => 'Database user name',
  :description => 'The database user name.',
  :default => 'mt'

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

# SSL attributes.

attribute 'mt_prereq/ssl/certificate_file',
  :display_name => 'Path to SSL certificate file',
  :description => 'The path to the SSL certificate file.',
  :default => '/etc/ssl/certs/ssl-cert-snakeoil.pem'

attribute 'mt_prereq/ssl/key_file',
  :display_name => 'Path to SSL key file',
  :description => 'The path to the SSL private key file.',
  :default => '/etc/ssl/private/ssl-cert-snakeoil.key'

attribute 'mt_prereq/ssl/chain_file',
  :display_name => 'Path to SSL CA chain file',
  :description => 'The path to the Certificate Authority issued chain file.',
  :default => ''
