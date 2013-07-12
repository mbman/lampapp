name              "LAMPapp"
maintainer        "Mario Baricevic"
maintainer_email  "mario.baricevic@gmail.com"
license           "GPL v3"
description       "Installs and configures a full LAMP server for a webapp"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.1"
recipe            "lampapp", "Includes the LAMP recipe to configure a typical web app"

depends "apt", "= 1.8.2"
depends "build-essential"
depends "openssl"
depends "selfsigned_certificate"
depends "xml"
depends "apache2"
depends "php"
depends "mysql"
depends "mysql::server"
depends "database"
depends "database::mysql"

attribute "lamapp/name",
  :display_name => "App name",
  :description => "The name for your 'name.dev' domain and mysql db",
  :default => "vagrant"

attribute "lamapp/password",
  :display_name => "App password",
  :description => "Used for mysql root user, ssl passphrase",
  :default => "foobar"

attribute "lamapp/ip",
  :display_name => "IP",
  :description => "Used as static virtualhost IP and mysql remote connections",
  :default => "192.168.56.101"