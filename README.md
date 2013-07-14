DESCRIPTION
===========

A **Vagrant Chef cookbook** recipe for setting up **LAMP webapp** VM server for your project.

Creates a **MySQL** DB and **Apache2** virtual host with **ssl** support and installs usefull dev tools like **Composer** and **Git**.

Virtual host alias is "vagrant.dev" with wildcard subdomains and 
auto-generated self-signed SSL cerfiticate support.

Set `config["lampapp"]["path"]` to the path of your public web directory relative to web root.


Mysql can be accessed remotley via `node["lampapp"]["ip"]` attribute IP as root:foobar


REQUIREMENTS
------------

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
---------------------

Clone this repo into your existing project to get your Vagrant server up in seconds:
  
https://github.com/mbman/lampapp-vagrant