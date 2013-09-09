# Attributes for the exratione cookbook.

# Database attributes.
default[:mt_prereq][:db][:database] = 'mt'
default[:mt_prereq][:db][:password] = 'password'
default[:mt_prereq][:db][:user] = 'mt'

# Server attributes.
default[:mt_prereq][:server][:hostname] = 'www.example.com'
default[:mt_prereq][:server][:aliases] = ['example.com']

# SSL attributes.
default[:mt_prereq][:ssl][:certificate_file] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
default[:mt_prereq][:ssl][:key_file] = '/etc/ssl/private/ssl-cert-snakeoil.key'
default[:mt_prereq][:ssl][:chain_file] = ''
