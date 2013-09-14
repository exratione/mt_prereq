# Path within the cgi-bin directory for the config file.
default[:mt_prereq][:mt_config][:config_file_path] = '/mt/mt-config.cgi'

# Database details not included in the default recipe attributes.
default[:mt_prereq][:mt_config][:db_object_driver] = 'DBI::mysql'
default[:mt_prereq][:mt_config][:db_host] = 'localhost'

# Memcached related items.
default[:mt_prereq][:mt_config][:use_memcached] = 'true'
default[:mt_prereq][:mt_config][:memcached_namespace] = 'mt'
default[:mt_prereq][:mt_config][:memcached_servers] = '127.0.0.1:11211'

# Whether to set some parameters that remove features from the admin homepage
# to speed it up.
default[:mt_prereq][:mt_config][:optimize_admin_homepage] = 'true'

# Mail transfer can be debug|sendmail|smtp.
default[:mt_prereq][:mt_config][:mail_transfer] = 'debug'
default[:mt_prereq][:mt_config][:sendmail_path] = '/usr/sbin/sendmail'
