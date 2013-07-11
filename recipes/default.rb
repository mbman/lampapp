node.set['apache']['default_modules'] = %w{rewrite deflate headers}
node.set['apache']['default_site_enabled'] = true

node.set['mysql']['server_root_password'] = node['lampapp']['password']
node.set['mysql']['server_repl_password'] = node['lampapp']['password']
node.set['mysql']['server_debian_password'] = node['lampapp']['password']
node.set['mysql']['remove_anonymous_users'] = true
node.set['mysql']['remove_test_database'] = true

# allow mysqladmin connections from any host
node.set['mysql']['allow_remote_root'] = true
node.set['mysql']['bind_address'] = node['lampapp']['ip']

include_recipe "apt"
include_recipe "openssl"
include_recipe "build-essential"
include_recipe "apache2"
include_recipe "jolicode-php"
include_recipe "mysql"
include_recipe "mysql::server"
include_recipe "database"
include_recipe "database::mysql"


mysql_database node['lampapp']['name'] do
    connection ({
        :host => node['lampapp']['ip'], 
        :username => 'root', 
        :password => node['mysql']['server_root_password']
    })
    action :create
end