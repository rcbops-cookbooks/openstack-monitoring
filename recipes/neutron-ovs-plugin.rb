# Cookbook Name:: openstack-monitoring
# Recipe:: neutron-ovs-plugin
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
if node.recipe?("nova-network::quantum-ovs-plugin")
  platform_options = node["nova-network"]["platform"]
  monitoring_procmon "quantum-ovs-plugin" do
    service_name=platform_options["quantum_ovs_service_name"]
    process_name "quantum-plugin-openvswitch-agent"
    script_name service_name
  end
end
