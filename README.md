DESCRIPTION
===========

A Vagrant Chef recipe for setting up LAMP webapp virtual machine server for your project.

Creates a MySQL DB and apache2 virtual host with ssl support.

Virtual host alias is "vagrant.dev" with wildcard subdomains and 
auto-generated self-signed SSL cerfiticate support.

Current project dir is shared to virtualhost's webroot.

Mysql can be accessed remotley via node["lampapp"]["ip"] attribute IP as root:foobar


REQUIREMENTS
============

The following cookbooks are required:

    - apt 1.8.2
    - apache2
    - mysql
    - database
    - jolicode-php
    - selfsigned_certificate

More Cookbooks info

    http://community.opscode.com/cookbooks

EXAMPLE
=======

The following Vagrantfile allows you to access current project dir using
a static IP adresss which you can map to ":name.dev" domain in you hosts config:

    # -*- mode: ruby -*-
    # vi: set ft=ruby :

    Vagrant.configure("2") do |config|
        config.vm.box = "precise64"
        config.vm.box_url = "http://files.vagrantup.com/precise64.box"
     
        config.vm.network :private_network, ip: "192.168.56.101"
        config.ssh.forward_agent = true

        config.vm.synced_folder "./", "/var/www", id: "vagrant-root"
        
        config.vm.provision "chef_solo" do |chef|
            chef.add_recipe "lampapp"

            chef.json.merge!({
                :lampapp => {
                    :name => "vagrant",
                    :password => "foobar",
                    :ip => "192.168.56.101"
                }
            })
        end
    end
