# Cookbook Name:: openstack-monitoring
# Recipe:: nova-api-ec2
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

if node.recipe?("nova::api-ec2") or node[:recipes].include?("nova::api-ec2")
	platform_options = node["nova"]["platform"]
	monitoring_procmon "nova-api-ec2" do
            service_name = platform_options["api_ec2_service"]
            pname = platform_options["api_ec2_process_name"]
            process_name pname
            script_name service_name
	end

	monitoring_metric "nova-api-ec2-proc" do
            type "proc"
            proc_name "nova-api-ec2"
            proc_regex platform_options["api_ec2_service"]

            alarms(:failure_min => 2.0)
	end
end
