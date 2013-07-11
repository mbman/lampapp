node.set['apache']['default_modules'] = %w{rewrite deflate headers php5 env expires}
node.set['apache']['default_site_enabled'] = true

node['php']['directives'] = {
    :display_errors => "On",
    :error_reporting => "E_ALL",
    :upload_max_filesize => "128M",
    :post_max_size => "128M"
}

node.set['mysql']['server_root_password'] = node['lampapp']['password']
node.set['mysql']['server_repl_password'] = node['lampapp']['password']
node.set['mysql']['server_debian_password'] = node['lampapp']['password']
node.set['mysql']['remove_anonymous_users'] = true
node.set['mysql']['remove_test_database'] = true

# allow mysqladmin connections from any host
node.set['mysql']['allow_remote_root'] = true
node.set['mysql']['bind_address'] = node['lampapp']['ip']

# php 5.4 support
node.set['jolicode-php']['dotdeb'] = true

include_recipe "apt"
include_recipe "build-essential"

# add dotdeb debian repository for PHP5.4
apt_repository "dotdeb" do
  uri "http://packages.dotdeb.org"
  distribution "squeeze-php54"
  components ["all"]
  key "http://www.dotdeb.org/dotdeb.gpg"
  deb_src true
  action :add
end

execute "apt-get update"

include_recipe "apache2"
include_recipe "php"
# install php modules
php_pear "xdebug" do
  # Specify that xdebug.so must be loaded as a zend extension
  zend_extensions ['xdebug.so']
  action :install
end
php_pear "memcache" do
  action :install
end
package "php5-apc" do
  action :install
end
package "php5-gd" do
  action :install
end
package "php5-curl" do
  action :install
end
package "php5-imagick" do
  action :install
end

include_recipe "jolicode-php"
include_recipe "jolicode-php::composer"
include_recipe "mysql"
include_recipe "mysql::server"
include_recipe "database"
include_recipe "database::mysql"

# run composer in project root
jolicode_php_composer "Install/update my dependencies" do
    cwd "/var/www"
    user "vagrant"
    options "--dev"
    action :update
end

# create mysql DB
mysql_database node['lampapp']['name'] do
    connection ({
        :host => node['lampapp']['ip'], 
        :username => 'root', 
        :password => node['mysql']['server_root_password']
    })
    action :create
end