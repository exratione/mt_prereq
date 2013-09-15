default[:mt_prereq][:db][:database] = 'mt'
default[:mt_prereq][:db][:password] = 'password'
default[:mt_prereq][:db][:user] = 'mt'
# Movable type encoding issues are legion, and so require that we specify
# default character set on the database. This has to match the default character
# set of whatever database you might be importing.
default[:mt_prereq][:db][:default_character_set] = 'latin1'

default[:mt_prereq][:server][:hostname] = 'www.example.com'
default[:mt_prereq][:server][:aliases] = ['example.com']

default[:mt_prereq][:perl][:memcached_driver] = 'Cache::Memcached::Fast'
