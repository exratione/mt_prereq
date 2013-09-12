# Where to obtain files from.
default[:mt_prereq][:ssl][:certificate_source_path] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
default[:mt_prereq][:ssl][:key_source_path] = '/etc/ssl/private/ssl-cert-snakeoil.key'
default[:mt_prereq][:ssl][:chain_source_path] = ''

# Where to copy files to.
default[:mt_prereq][:ssl][:certificate_path] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
default[:mt_prereq][:ssl][:key_path] = '/etc/ssl/private/ssl-cert-snakeoil.key'
default[:mt_prereq][:ssl][:chain_path] = ''
