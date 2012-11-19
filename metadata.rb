name             "fisheye"
maintainer       "SecondMarket Labs, LLC"
maintainer_email "systems@secondmarket.com"
license          "All rights reserved"
description      "Installs/Configures Atlassian Fisheye"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

%w{java}.each do |d|
  depends d
end
