name              "LAMPapp"
maintainer        "Mario Baricevic"
maintainer_email  "mario.baricevic@gmail.com"
license           "GPL"
description       "Installs and configures a full LAMP server for a webapp"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.1"
recipe            "lampapp", "Includes the LAMP recipe to configure a typical web app"

depends "apt", "1.8.0"
depends "build-essential"
depends "jolicode-php"
depends "apache2"
depends "mysql"
depends "database"