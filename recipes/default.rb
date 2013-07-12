node.set['apache']['default_modules'] = %w{rewrite deflate headers php5 env expires ssl}
node.set['apache']['default_site_enabled'] = false

# php 5.4 support
node.default['jolicode-php']['dotdeb'] = true
node.default['jolicode-php']['conf_dir'] = "/etc/php5/apache2"
node.default['jolicode-php']['config']['display_errors'] = "On"

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

include_recipe "apache2"
include_recipe "selfsigned_certificate"
include_recipe "jolicode-php"
include_recipe "jolicode-php::php"
include_recipe "jolicode-php::composer"
include_recipe "jolicode-php::ext-apc"
include_recipe "jolicode-php::ext-curl"
include_recipe "jolicode-php::ext-gd"
include_recipe "jolicode-php::ext-imagick"
include_recipe "jolicode-php::ext-intl"
include_recipe "jolicode-php::ext-mbstring"
include_recipe "jolicode-php::ext-twig"
include_recipe "jolicode-php::ext-xdebug"
include_recipe "mysql"
include_recipe "mysql::server"
include_recipe "database"
include_recipe "database::mysql"

# run composer in project root
jolicode_php_composer "Install/update Composer dependencies" do
    cwd "/var/www"
    user "vagrant"
    options "--dev --quiet"
    action :update
end

# create mysql DB
lampapp node['lampapp']['name']

# create mysql DB
mysql_database node['lampapp']['name'] do
    connection ({
        :host => node['lampapp']['ip'], 
        :username => 'root', 
        :password => node['mysql']['server_root_password']
    })
    action :create
end