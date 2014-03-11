name             'graphite_reporting_handler'
maintainer       'Greg Albrecht'
maintainer_email 'gba@onbeep.com'
license          'Apache License, Version 2.0'
description      'Installs & Configures the Chef Graphite Reporting Handler.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'chef_handler'

suggests 'ohai-system_packages'
