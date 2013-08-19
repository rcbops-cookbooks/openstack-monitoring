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
if node['nova']['network']['provider'] == 'nova'
  platform_options = node["nova-network"]["platform"]
  if node.recipe?("nova-network::nova-controller") || node.recipe?("nova-network::nova-compute")
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
elsif node['nova']['network']['provider'] == 'quantum'

  platform_options = node["quantum"]["platform"]

  quantum_services = {
    'quantum_api_service' => {
      'recipe' => 'nova-network::quantum-server'
    },
    'quantum-dhcp-agent' => {
      'recipe' => 'nova-network::quantum-dhcp-agent'
    },
    'quantum-l3-agent' => {
      'recipe' => 'nova-network::quantum-l3-agent'
    },
    'quantum-metadata-agent' => {
      'recipe' => 'nova-network::quantum-metadata-agent'
    },
    'quantum_ovs_service_name' => {
      'recipe' => 'nova-network::quantum-ovs-plugin',
      'process' => 'quantum-openvswitch-agent'
    },
    "#{platform_options['quantum_openvswitch_service_name']}_ovsdb_server" => {
      'recipe' => 'nova-network::quantum-ovs-plugin',
      'process' => 'ovsdb-server',
      'service' => 'quantum_openvswitch_service_name'
    },
    "#{platform_options['quantum_openvswitch_service_name']}_ovs_vswitchd" => {
      'recipe' => 'nova-network::quantum-ovs-plugin',
      'process' => 'ovs-vswitchd',
      'service' => 'quantum_openvswitch_service_name'
    }
  }

  quantum_services.each_pair do |svc, values|
    if run_context.loaded_recipe?(values['recipe']) || node.recipe?(values['recipe'])
      monitoring_procmon platform_options[svc] || svc do
        service_name = platform_options[values['service']] || platform_options[svc]
        process_name values['process'] || platform_options[svc]
        script_name service_name
      end

      mon_metric_name = platform_options[svc] || svc
      monitoring_metric "#{mon_metric_name}-proc" do
        type "proc"
        proc_name values['process'] || platform_options[svc]
        proc_regex values['process'] || platform_options[svc]
        alarms(:failure_min => 2.0)
      end
    end
  end
end
