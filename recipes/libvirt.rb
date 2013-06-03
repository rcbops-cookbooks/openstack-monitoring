# Cookbook Name:: openstack-monitoring
# Recipe:: libvirt
#
# Copyright 2013, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
include_recipe "monitoring"

if node.recipe?("nova::libvirt")
  platform_options = node["nova"]["platform"]
  monitoring_procmon "libvirt-bin" do
    service_name=platform_options["libvirt_service"]
    process_name "libvirtd"
    script_name service_name
  end

  monitoring_metric "libvirtd-proc" do
    type "proc"
    proc_name "libvirtd-consoleauth"
    proc_regex platform_options["libvirt_service"]
    alarms(:failure_min => 1.0)
  end

  monitoring_metric "libvirt" do
    type "libvirt"
  end
end
