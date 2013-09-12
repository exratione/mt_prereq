#
# Add import of a mysqldump file (or other SQL) to the MT database.
#

# Load data into the new database if we have an import file. All of the
# more chefish ways of doing this are not so good in practice, so go with plain
# execute and just use the mysql client directly.
execute 'import SQL database' do
  command "mysql -uroot -p#{node[:mysql][:server_root_password]} #{node[:mt_prereq][:db][:database]} < #{node[:mt_prereq][:import_sql][:file_path]}"
  path ["/usr/bin"]
end



