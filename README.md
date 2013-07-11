DESCRIPTION
===========

A Vagrant Chef recipe for setting up LAMP webapps on Ubuntu / Debian systems.

Creates a MySQL DB and a apache2 virtual host with ssl support.

Vritual host alias is vagrant.dev with wildcard subdomains and ssl support.
'vagrant' is the default lampapp "name" recipe attribute.

Current project dir will be shared to virtualhost's root dir.

Mysql can be accessed remotley via 192.168.56.101 ip address as root:foobar
'foobar' is the default lamapp "password" recipe attribute.

REQUIREMENTS
============

The following cookbooks are required:

    - apt
    - apache2
    - mysql
    - database
    - ssl-cookbok

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
                    :password => "foobar"
                }
            })
        end
    end
