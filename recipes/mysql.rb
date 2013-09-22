#
# A recipe to configure an existing MySQL database.
#

# Use the database cookbook functions to get the MySQL database set up.
mysql_connection_info = {
  :host => 'localhost',
  :username => 'root',
  :password => node[:mysql][:server_root_password]
}

# Add the database. Because encoding matters in Movable Type - i.e. it may have
# been putting utf8 data into latin1 tables in a latin1 database -- we have to
# specify character sets. If the default character set on the import database
# doesn't match that on the export database then there will be issues, and by
# default the database cookbook tools create utf8 databases.
mysql_database node[:mt_prereq][:db][:database] do
  connection mysql_connection_info
  encoding node[:mt_prereq][:db][:default_character_set]
  action :create
end

# Create user and set the grants.
mysql_database_user node[:mt_prereq][:db][:user] do
  connection mysql_connection_info
  password node[:mt_prereq][:db][:password]
  database_name node[:mt_prereq][:db][:database]
  host 'localhost'
  privileges [:all]
  action :grant
end
