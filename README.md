Movable Type Prerequisites Cookbook
===================================

This cookbook is used to build a server ready for Movable Type 4 or 5 to be
dropped into the webroot. The result is a LAMP server with the necessary
additional Perl dependencies for Movable Type.

It specifies and includes all the necessary third party cookbook dependencies,
so is good for use with a cookbook manager like librarian-chef.

This was built for use in the development Vagrant-plus-Chef setup, wherein the
Movable Type webroot is a git repository, and that folder is shared with the
virtual machine's webroot. Thus Movable Type doesn't have to be copied into
place by the cookbook.

Attributes
----------

See the metadata for details: optional versus required, string versus array,
which have defaults, and so on.

  * node['mt_prereq']['db']['database']
  * node['mt_prereq']['db']['mysqldump_file_path']
  * node['mt_prereq']['db']['password']
  * node['mt_prereq']['db']['user']

  * node['mt_prereq']['server']['hostname']
  * node['mt_prereq']['server']['aliases']

  * node['mt_prereq']['ssl']['certificate_file']
  * node['mt_prereq']['ssl']['key_file']
  * node['mt_prereq']['ssl']['chain_file']

Attributes from dependent cookbooks that must be set:

  * node['mysql']['server_root_password']
  * node['mysql']['server_debian_password']
  * node['mysql']['server_repl_password']

  * node['apache']['docroot_dir']
  * node['apache']['cgibin_dir']

Attributes from dependent cookbooks that probably should be set, especially for
a production environment:

  * Many of the other Apache2 cookbook attributes.
