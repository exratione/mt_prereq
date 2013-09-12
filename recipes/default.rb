#
# Main recipe to set up a LAMP server ready for Movable Type 4 or 5.
#
# Sets up the following:
#
# - MySQL (without any import of data)
# - Apache (without mod_ssl).
# - Perl and PHP
# - Memcached
#

# Declare that we want all of these recipies.
include_recipe 'mysql'
include_recipe 'mysql::server'
# Provides mysql_* convenience functions.
include_recipe 'database::mysql'
include_recipe 'apache2'
include_recipe 'apache2::mod_fcgid'
include_recipe 'apache2::mod_ssl'
include_recipe 'php'
include_recipe 'php::module_apc'
include_recipe 'php::module_memcache'
# Perl recipe provides cpan_module command.
include_recipe 'perl'
include_recipe 'memcached'

# ----------------------------------------------------------------
# General server config.
# ----------------------------------------------------------------

# Set site hostname.
file '/etc/hostname' do
  content "#{node[:mt_prereq][:server][:hostname]}\n"
end

service 'hostname' do
  action :restart
end

# Overwrite /etc/hosts with the relevant hostnames.
file '/etc/hosts' do
  content "127.0.0.1 localhost #{node[:mt_prereq][:server][:hostname]} #{node[:mt_prereq][:server][:aliases]}\n"
end

# Recreate a snakeoil cert such that it has the right hostname. Start by making
# sure that the ssl-cert package is installed.
package 'ssl-cert' do
  action :install
end
# And then run the command.
execute 'recreate snakeoil certificate' do
  command 'make-ssl-cert generate-default-snakeoil --force-overwrite'
end

# ----------------------------------------------------------------
# MySQL
# ----------------------------------------------------------------

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

# Load data into the new database if we have an import file. All of the
# more chefish ways of doing this are not so good in practice, so go with plain
# execute and just use the mysql client directly.
if "#{node[:mt_prereq][:db][:mysqldump_file_path]}" != ''
  execute 'import SQL database' do
    command "mysql -uroot -p#{node[:mysql][:server_root_password]} #{node[:mt_prereq][:db][:database]} < #{node[:mt_prereq][:db][:mysqldump_file_path]}"
    path ["/usr/bin"]
  end
end

# ----------------------------------------------------------------
# Perl.
# ----------------------------------------------------------------

# Note that we're loading some extra cookbook recipies in here. The dependencies
# require this order.
cpan_module 'Crypt::DSA'
cpan_module 'IPC::Run'
cpan_module 'Archive::Zip'
cpan_module 'HTML::Parser'
cpan_module 'HTML::Entities'
cpan_module 'Cache::File'
cpan_module 'Crypt::SSLeay'

# No luck getting the Perl API for imagemagick to install via cpan, so do it
# via apt package. Since I'm doing that, may as well use the apt package for
# imagemagick anyway. Using the imagemagick cookbook is just overkill for what I
# want to do here, and it doesn't deal with perlmagick correctly anyway.
case node[:platform]
when "redhat", "centos", "fedora"
  package "ImageMagick"
when "debian", "ubuntu"
  package "imagemagick"
end

package "perlmagick" do
  case node[:platform]
  when "centos","redhat","fedora","suse"
    package_name "ImageMagick-perl"
  when "debian","ubuntu"
    package_name "perlmagick"
  end
  action :install
end

# Needed for GD install in cpan.
package "libgd2-xpm-dev"

cpan_module 'GD'
cpan_module 'Digest::SHA1'
cpan_module 'HTML::Parser'

include_recipe 'xml'

cpan_module 'XML::Atom'
cpan_module 'XML::Parser'
cpan_module 'Mail::Sendmail'
cpan_module 'Cache::Memcached::Fast'

# ----------------------------------------------------------------
# Apache
# ----------------------------------------------------------------

# Disable the default sites.
apache_site 'default' do
  enable false
end
apache_site 'default-ssl' do
  enable false
end

# Set up non-SSL virtual host.
web_app "#{node[:mt_prereq][:server][:hostname]}" do
  template 'virtual_host.erb'
  allow_override 'All'
  directory_options 'FollowSymLinks ExecCGI'
  directory_index 'index.php index.html'
end

# Set up SSL virtual host.
web_app "#{node[:mt_prereq][:server][:hostname]}-ssl" do
  template 'virtual_host_ssl.erb'
  allow_override 'All'
  directory_options 'FollowSymLinks ExecCGI'
  directory_index 'index.php index.html'
end

# Copy in mod_fcgid custom configuration.
template "/etc/apache2/mods-available/fcgid.conf" do
  path "/etc/apache2/mods-available/fcgid.conf"
  source "mods/fcgid.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  # No variables in this one for now.
  variables()
end

# Restart Apache to pick up that change.
service 'apache2' do
  action :restart
end

# ----------------------------------------------------------------
# Monit
# ----------------------------------------------------------------

# Add in config files.


# ----------------------------------------------------------------
# Movable Type
# ----------------------------------------------------------------

# Substitute in a suitable mt-config.cgi configuration file.
# OR move this to another cookbook?

