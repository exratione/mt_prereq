#
# Recipe to copy in a MT template.
#

template 'mt-config.cgi' do
  path "#{node[:apache][:cgibin_dir]}#{node[:mt_prereq][:mt_config][:config_file_path]}"
  source "mt-config.cgi.erb"
  backup false
  mode 755
end

# If mail is sent via sendmail, then we need to ensure that sendmail is
# installed.
if node[:mt_prereq][:mt_config][:mail_transfer] == 'sendmail'
  package 'sendmail' do
    action :install
  end
  service 'sendmail' do
    action [ :enable, :start ]
  end
end
