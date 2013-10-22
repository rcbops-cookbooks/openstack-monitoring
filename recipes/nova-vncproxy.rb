# Cookbook Name:: openstack-monitoring
# Recipe:: vncproxy
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

if node.recipe?("nova::vncproxy")
  platform_options = node["nova"]["platform"]

  monitoring_procmon platform_options["nova_vncproxy_service"] do
    process_name platform_options["nova_vncproxy_procmatch"]
    script_name platform_options["nova_vncproxy_service"]
  end

  monitoring_metric "nova-novncproxy-proc" do
    type "proc"
    proc_name "nova-novncproxy"
    proc_regex platform_options["nova_vncproxy_service"]
    alarms(:failure_min => 2.0)
  end

  monitoring_procmon "nova-consoleauth" do
    process_name platform_options["nova_vncproxy_consoleauth_procmatch"]
    script_name platform_options["nova_vncproxy_consoleauth_service"]
  end

  monitoring_metric "nova-consoleauth-proc" do
    type "proc"
    proc_name "nova-consoleauth"
    proc_regex platform_options["nova_vncproxy_consoleauth_service"]
    alarms(:failure_min => 1.0)
  end
end
