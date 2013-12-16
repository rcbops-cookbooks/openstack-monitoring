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
      process_name platform_options["nova_network_procmatch"]
      script_name platform_options["nova_network_service"]
    end

    monitoring_metric "nova-network-proc" do
      type "proc"
      proc_name "nova-network"
      proc_regex platform_options["nova_network_service"]
      alarms(:failure_min => 2.0)
    end
  end
elsif node['nova']['network']['provider'] == 'neutron'

  platform_options = node["neutron"]["platform"]
  procmatch_base = '^((/usr/bin/)?python\d? )?(/usr/bin/)?'

  # TODO(brett): this needs to be unwound/abstracted out of here a bit more
  neutron_services = {
    'neutron_api_service' => {
      'recipe' => 'nova-network::neutron-server',
      'process' => procmatch_base + 'neutron-server\b'
    },
    'neutron-dhcp-agent' => {
      'recipe' => 'nova-network::neutron-dhcp-agent',
      'process' => procmatch_base + 'neutron-dhcp-agent\b'
    },
    'neutron-l3-agent' => {
      'recipe' => 'nova-network::neutron-l3-agent',
      'process' => procmatch_base + 'neutron-l3-agent\b'
    },
    'neutron-metadata-agent' => {
      'recipe' => 'nova-network::neutron-metadata-agent',
      'process' => procmatch_base + 'neutron-metadata-agent\b'
    },
    'neutron-lbaas-agent' => {
      'recipe' => 'nova-network::neutron-lbaas-agent',
      'process' => procmatch_base + 'neutron-lbaas-agent\b'
    },
    'neutron_ovs_service_name' => {
      'recipe' => 'nova-network::neutron-ovs-plugin',
      'process' => procmatch_base + 'neutron-openvswitch-agent\b'
    },
    "#{platform_options['neutron_openvswitch_service_name']}_ovsdb_server" => {
      'recipe' => 'nova-network::neutron-ovs-plugin',
      'process' => '^ovsdb-server\s',
      'service' => 'neutron_openvswitch_service_name'
    },
    "#{platform_options['neutron_openvswitch_service_name']}_ovs_vswitchd" => {
      'recipe' => 'nova-network::neutron-ovs-plugin',
      'process' => '^ovs-vswitchd\s',
      'service' => 'neutron_openvswitch_service_name'
    },
    'rpcdaemon' => {
      'recipe' => 'nova-network::rpcdaemon',
      'process' => procmatch_base + 'rpcdaemon\b'
    }
  }

  # remove old quantums first
  %w(dhcp-agent l3-agent metadata-agent server).each do |name|
    monitoring_procmon "quantum-#{name}" do
      action :remove
    end
  end

  neutron_services.each_pair do |svc, values|
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
