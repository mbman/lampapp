require 'fileutils'
node.normal['apache']['version'] = "2.4"
node.normal['apache']['default_modules'] = %w{rewrite deflate headers php5 env expires ssl proxy proxy_fcgi}
node.normal['apache']['default_site_enabled'] = false

node.normal['php']['conf_dir'] = "/etc/php5/apache2"
node.normal['php']['directives']['display_errors'] = "On"
node.normal['ssl_certificate']['key_dir']= "/home/vagrant/"
node.normal['ssl_certificate']['cert_dir']= "/home/vagrant/"

# SSL certificate
node.default['lampapp_ssl'] = {
    :country => "HR",
    :state => "HR",
    :city => "MyCity",
    :organization => "MyOrg",
    :department => "MyDept",
    :common_name => "*.#{node['lampapp']['name']}.dev",
    :email => "admin@localhost"
}
node.default['lampapp_ssl']['ssl_key']['source'] = 'self-signed'

cert = ssl_certificate 'lampapp_ssl' do
  namespace node['lampapp_ssl']
end

node.normal[:sphinx][:use_mysql] = true
node.normal[:sphinx][:version] = '2.2.5'
node.normal['build-essential']['compile_time'] = true
node.normal["percona"]["use_percona_repos"] = false
node.normal['percona']['skip_configure'] = true
node.normal["percona"]["client"]["packages"] = []

include_recipe "apt"
execute "compile-time-apt-get-update" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end.run_action(:run)

[
  "build-essential",
  "xml",
  "git",
  "curl::default"
].each do |recipe|
  include_recipe recipe
end

mysql_service 'vagrant' do
  port '3306'
  bind_address '0.0.0.0'
  initial_root_password node['lampapp']['password']
  action [:create, :start]
end

mysql_config 'vagrant' do
  source 'mysql.conf.erb'
  notifies :restart, 'mysql_service[vagrant]'
  action :create
end

mysql_client 'default' do
  action :create
end

mysql2_chef_gem 'default' do
  action :install
end

[
  "redisio",
  "redisio::enable",
].each do |recipe|
  include_recipe recipe
end

# create php's apache2 config dir
phpiniDir = "/etc/php5/apache2"
FileUtils.mkdir_p(phpiniDir) unless File.exists?(phpiniDir)

include_recipe "apache2"
include_recipe "sphinx::source"

mysql_database node['lampapp']['name'] do
  connection(
    :host     => '0.0.0.0',
    :username => 'root',
    :password => node['lampapp']['password']
  )
  action :create
end

[
  "php5-xdebug",
  "php5-mysql",
  "php5-gd",
  "php5-imagick",
  "php5-memcached",
  "php5-curl",
  "php5-intl",
  "php5-xsl",
  "php5-mcrypt",
  "php5-redis"
].each do |php_package|
  package php_package do
    action :install
  end
end

php_fpm_pool "default" do
  action :install
end

# composer global install
execute "curl -sS https://getcomposer.org/installer | php -- --install-dir=bin --filename=composer"

# default app
lampapp node['lampapp']['name']