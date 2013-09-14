#
# A recipe to configure an existing MySQL database.
#

# Use the database cookbook functions to get the MySQL database set up.
mysql_connection_info = {
  :host => 'localhost',
  :username => 'root',
  :password => node[:mysql][:server_root_password]
}

# Add the exratione database.
mysql_database node[:mt_prereq][:db][:database] do
  connection mysql_connection_info
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
