name             "openstack-monitoring"
maintainer       "Rackspace US, Inc."
license          "Apache 2.0"
description      "Installs/Configures openstack-monitoring"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          IO.read(File.join(File.dirname(__FILE__), "VERSION"))

%w{ centos ubuntu }.each do |os|
  supports os
end

%w{ keystone monitoring osops-utils }.each do |dep|
  depends dep
end
