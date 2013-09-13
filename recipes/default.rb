#
# Main recipe to set up a LAMP server ready for Movable Type 4 or 5.
#
# Sets up configuration and the like for the following, which must already
# have been installed via other cookbooks.
#
# - MySQL (without any import of data)
# - Apache (without mod_ssl).
# - Perl and PHP
# - Memcached
#

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
# OR move this to another recipe?

