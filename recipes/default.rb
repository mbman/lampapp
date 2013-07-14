node.set['apache']['default_modules'] = %w{rewrite deflate headers php5 env expires ssl}
node.set['apache']['default_site_enabled'] = false

# SSL certificate
node.set['selfsigned_certificate'] = {
    :country => "HR",
    :state => "HR",
    :city => "MyCity",
    :orga => "MyOrg",
    :depart => "MyDept",
    :cn => "*.#{node['lampapp']['name']}.dev",
    :email => "admin@localhost",
    :destination => "/etc/apache2/ssl/",
    :sslpassphrase => node['lampapp']['password']
}

node.set['mysql']['server_root_password'] = node['lampapp']['password']
node.set['mysql']['server_repl_password'] = node['lampapp']['password']
node.set['mysql']['server_debian_password'] = node['lampapp']['password']
node.set['mysql']['remove_anonymous_users'] = true
node.set['mysql']['remove_test_database'] = true

# allow mysqladmin connections from any host
node.set['mysql']['allow_remote_root'] = true
node.set['mysql']['bind_address'] = node['lampapp']['ip']

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

include_recipe "selfsigned_certificate"
include_recipe "mysql"
include_recipe "mysql::server"
include_recipe "database"
include_recipe "database::mysql"
include_recipe "xml"
include_recipe "git"
include_recipe "php"
php_pear "xdebug" do
  zend_extensions ['xdebug.so']
  action :install
end
php_pear "APC" do
  action :install
  directives(:shm_size => 128, :enable_cli => 1)
end
php_pear "memcache" do
  action :install
end
package "php5-gd" do
  action :install
end
package "php5-imagick" do
  action :install
end
package "php5-curl" do
  action :install
end
package "php5-intl" do
  action :install
end
include_recipe "apache2"

# composer global install
execute "curl -sS https://getcomposer.org/installer | php"
execute "sudo mv composer.phar /usr/local/bin/composer"

# create mysql DB
mysql_database node['lampapp']['name'] do
    connection ({
        :host => node['lampapp']['ip'], 
        :username => 'root', 
        :password => node['mysql']['server_root_password']
    })
    action :create
end

# default app
lampapp node['lampapp']['name']