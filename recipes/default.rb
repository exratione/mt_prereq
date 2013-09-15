#
# Main recipe to configure a LAMP server to be ready for Movable Type 4 or 5.
#
# Sets up configuration for the following:
#
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
# Perl.
# ----------------------------------------------------------------

cpan_module 'Crypt::DSA'
cpan_module 'IPC::Run'
cpan_module 'Archive::Zip'
cpan_module 'HTML::Parser'
cpan_module 'HTML::Entities'
cpan_module 'Cache::File'
cpan_module 'Crypt::SSLeay'

# Note that it gets quite slow here - these are long installs until we're done
# with GD.

# No luck getting the Perl API for imagemagick to install via cpan, so do it
# via apt package. Since I'm doing that, may as well use the apt package for
# imagemagick anyway. Using the imagemagick cookbook is just overkill for what
# we want to do here, and it doesn't deal with perlmagick correctly anyway.
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
cpan_module node[:mt_prereq][:perl][:memcached_driver]

# FCGI package for Perl.
fcgi_package = value_for_platform(
  %w(redhat centos fedora scientific) => {
    %w(5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8) => 'fcgi-perl',
    'default' => 'perl-FCGI'
  },
  'default' => 'libfcgi-perl'
)
package fcgi_package

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
# PHP
# ----------------------------------------------------------------

# No configuration at this time: use the options in the PHP cookbook.

# ----------------------------------------------------------------
# Memcached
# ----------------------------------------------------------------

# No configuration at this time: use the options in the Memcached cookbook.

# The restart isn't strictly necessary, but it makes it a lot easier to test
# repeated provisioning - clearing out the old cached data needs to happen.
service 'memcached' do
  action :restart
end
