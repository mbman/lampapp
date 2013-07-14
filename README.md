DESCRIPTION
===========

A Vagrant Chef recipe for setting up LAMP webapp virtual machine server for your project.

Creates a MySQL DB and apache2 virtual host with ssl support.

Virtual host alias is "vagrant.dev" with wildcard subdomains and 
auto-generated self-signed SSL cerfiticate support.

Set "config.vm.synced_folder" in your Vagrantfile to the root web directory path,
and the "config.lampapp.path" to the relative path of your public web directory.

Mysql can be accessed remotley via node["lampapp"]["ip"] attribute IP as root:foobar


REQUIREMENTS
============

The following cookbooks are required:

  - apt 1.8.2
  - apache2
  - mysql
  - database
  - openssl
  - xml
  - php
  - git
  - selfsigned_certificate

More Cookbooks info: http://community.opscode.com/cookbooks

EXAMPLE VAGRANT SETUP
=====================
  
https://github.com/mbman/lampapp-vagrant