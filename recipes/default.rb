node.set['apache']['default_modules'] = [
    "rewrite",
    "deflate",
    "headers",
    "php5"
]
node.set['apache']['default_site_enabled'] = true

node.set['mysql']['server_root_password'] = "foobar"
node.set['mysql']['server_repl_password'] = "foobar"
node.set['mysql']['server_debian_password'] = "foobar"
node.set['mysql']['remove_anonymous_users'] = true
node.set['mysql']['remove_test_database'] = true

# allow mysqladmin connections from any host
node.set['mysql']['allow_remote_root'] = true

include_recipe "apt"
include_recipe "openssl"
include_recipe "build-essential"
include_recipe "apache2"
include_recipe "jolicode-php"
include_recipe "mysql"
include_recipe "mysql::server"