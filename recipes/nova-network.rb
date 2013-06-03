# Cookbook Name:: openstack-monitoring
# Recipe:: nova-network
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

# nova-network monitoring setup..
if node.recipe?("nova-network::nova-controller") or node.recipe?("nova-network::nova-compute")
  platform_options = node["nova-network"]["platform"]
  monitoring_procmon "nova-network" do
    service_name=platform_options["nova_network_service"]
    process_name "nova-network"
    script_name service_name
  end

  monitoring_metric "nova-network-proc" do
    type "proc"
    proc_name "nova-network"
    proc_regex platform_options["nova_network_service"]
    alarms(:failure_min => 2.0)
  end
end
