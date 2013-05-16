# Cookbook Name:: openstack-monitoring
# Recipe:: nova-compute
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

if node.recipe?("nova::compute") or node[:recipes].include?("nova::compute")
    platform_options = node["nova"]["platform"]
    monitoring_procmon "nova-compute" do
        service_name=platform_options["nova_compute_service"]
        process_name "nova-compute"
        script_name service_name
    end

    monitoring_metric "nova-compute-proc" do
        type "proc"
        proc_name "nova-compute"
        proc_regex platform_options["nova_compute_service"]

        alarms(:failure_min => 2.0)
    end
end
