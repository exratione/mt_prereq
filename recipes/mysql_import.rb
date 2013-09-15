#
# Import a mysqldump file (or other SQL) to the MT database.
#

# Load data into the new database. All of the more chefish ways of doing this
# are not so good in practice, so go with plain execute and just use the mysql
# client directly.
#
# Movable Type has in the past stuck utf8 data in latin1 tables by default, in
# a latin1 database. This means that the way to get a useful export file out of
# mysqldump is this:
#
# mysqldump -uroot -p --default-character-set=latin1 database_name > file.sql
#
# And for import:
#
# mysql -uroot -p database_name < file.sql
#
# The unicode in this file won't be properly recognized on import, however,
# unless the database it is imported to has a latin1 default character set as
# well. Generally Chef cookbooks will create utf8 databases by default - so
# something to watch out for there.
#
# This cookbook allows specification of character set.
#
# This is why many people go to the trouble of converting Movable Type schema
# to UTF-8, at which point it all just works without the character encoding
# concerns. If you've done this, you can specify utf8 as the default encoding
# in this cookbook.
#
execute 'import SQL database' do
  command "mysql -uroot -p#{node[:mysql][:server_root_password]} #{node[:mt_prereq][:db][:database]} < #{node[:mt_prereq][:mysql_import][:file_path]}"
  path ['/usr/bin']
end
