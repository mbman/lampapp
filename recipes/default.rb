require 'fileutils'
node.normal['apache']['default_modules'] = %w{rewrite deflate headers php5 env expires ssl}
node.normal['apache']['default_site_enabled'] = false

node.normal['php']['conf_dir'] = "/etc/php5/apache2"
node.normal['php']['directives']['display_errors'] = "On"

# SSL certificate
node.normal['selfsigned_certificate'] = {
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

node.normal['mysql']['server_root_password'] = node['lampapp']['password']
node.normal['mysql']['server_repl_password'] = node['lampapp']['password']
node.normal['mysql']['server_debian_password'] = node['lampapp']['password']
node.normal['mysql']['remove_anonymous_users'] = true
node.normal['mysql']['remove_test_database'] = true

# allow mysqladmin connections from any host
node.normal['mysql']['allow_remote_root'] = true
node.normal['mysql']['bind_address'] = node['lampapp']['ip']

[
  "apt",
  "build-essential",
  "selfsigned_certificate",
  "xml",
  "git"
].each do |recipe|
  include_recipe recipe
end

execute "compile-time-apt-get-update" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end.run_action(:run)

[
  "mysql::server",
  "database",
  "database::mysql",
].each do |recipe|
  include_recipe recipe
end

# create php's apache2 config dir
phpiniDir = "/etc/php5/apache2"
FileUtils.mkdir_p(phpiniDir) unless File.exists?(phpiniDir)

include_recipe "php"

[
  "php5-xdebug",
  "php-apc",
  "php5-mysql",
  "php5-gd",
  "php5-imagick",
  "php5-memcached",
  "php5-curl",
  "php5-intl",
  "php5-xsl"
].each do |php_package|
  package php_package do
    action :install
  end
end
include_recipe "apache2"

# composer global install
execute "curl -sS https://getcomposer.org/installer | php"
execute "sudo mv composer.phar /usr/local/bin/composer"

service "mysql" do
  action :restart
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

# default app
lampapp node['lampapp']['name']