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
place by the cookbook. This suits MT deployments in which the base MT code is
modified, or in which the webroot includes a lot of supplementary PHP or other
code, for example.

default
-------

The default recipe installs and configures Apache2, PHP, Perl, Memcached, and
Monit.

  * `node['mt_prereq']['db']['database']`
  * `node['mt_prereq']['db']['password']`
  * `node['mt_prereq']['db']['user']`

  * `node['mt_prereq']['server']['hostname']`
  * `node['mt_prereq']['server']['aliases']`

Attributes from dependent cookbooks that must be set:

  * `node['mysql']['server_root_password']`
  * `node['mysql']['server_debian_password']`
  * `node['mysql']['server_repl_password']`

  * `node['apache']['docroot_dir']`
  * `node['apache']['cgibin_dir']`

Attributes from dependent cookbooks that probably should be set, especially for
a production environment:

  * Many of the other Apache2 cookbook attributes.

import_sql
----------

Imports a mysqldump backup of a site database or other SQL into the database
connection specified for the default recipe.

  * `node['mt_prereq']['import_sql']['file_path']`

ssl
---

The SSL recipe installs and configures mod_ssl, with either a snakeoil
self-signed certificate, or copies in a certificate provided.

The following attributes determine where the certificate files are sourced, and
where they are copied to in the server. If all of the attributes are omitted,
the server will default to using a self-signed certificate.

  * `node['mt_prereq']['ssl']['certificate_source_path']`
  * `node['mt_prereq']['ssl']['key_source_path']`
  * `node['mt_prereq']['ssl']['chain_source_path']`

  * `node['mt_prereq']['ssl']['certificate_path']`
  * `node['mt_prereq']['ssl']['key_path']`
  * `node['mt_prereq']['ssl']['chain_path']`
