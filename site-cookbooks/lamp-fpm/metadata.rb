name             'lamp-fpm'
maintainer       'Sergey Sytchewoj'
maintainer_email 's.sytchewoj@gmail.com'
license          'GPL v3'
description      'Installs/Configures lamp-fpm'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends			 'apache2'

depends 		 'database'

depends			 'mysql'
depends			 'php-fpm'