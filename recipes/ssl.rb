#
# Recipe to configure a suitable SSL virtual host in Apache2.
#
# Expects apache2::mod_ssl to be installed.
#

# ----------------------------------------------------------------
# Regenerate snakeoil certificate.
# ----------------------------------------------------------------

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
# Apache
# ----------------------------------------------------------------

# Set up SSL virtual host.
web_app "#{node[:mt_prereq][:server][:hostname]}-ssl" do
  template 'virtual_host_ssl.erb'
  allow_override 'All'
  directory_options 'FollowSymLinks ExecCGI'
  directory_index 'index.php index.html'
end

# ----------------------------------------------------------------
# Certificates.
# ----------------------------------------------------------------

if node[:mt_prereq][:ssl][:certificate_source_path] != node[:mt_prereq][:ssl][:certificate_path]
  remote_file 'key' do
    path node[:mt_prereq][:ssl][:certificate_path]
    source "file://#{node[:mt_prereq][:ssl][:certificate_source_path]}"
    user 'root'
    group 'root'
    mode 0644
  end
end

if node[:mt_prereq][:ssl][:key_source_path] != node[:mt_prereq][:ssl][:key_path]
  remote_file 'key' do
    path node[:mt_prereq][:ssl][:key_path]
    source "file://#{node[:mt_prereq][:ssl][:key_source_path]}"
    user 'root'
    group 'root'
    mode 0600
  end
end

if node[:mt_prereq][:ssl][:chain_source_path] != node[:mt_prereq][:ssl][:chain_path]
  remote_file 'key' do
    path node[:mt_prereq][:ssl][:chain_path]
    source "file://#{node[:mt_prereq][:ssl][:chain_source_path]}"
    user 'root'
    group 'root'
    mode 0644
  end
end
