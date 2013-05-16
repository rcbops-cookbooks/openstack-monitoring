# Cookbook Name:: openstack-monitoring
# Recipe:: glance-api
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

# Glance monitoring setup..
if node.recipe?("glance::glance-api") or node[:recipes].include?("glance::glance-api")
	platform_options = node["glance"]["platform"]
	monitoring_procmon "glance-api" do
            sname = platform_options["glance_api_service"]
            pname = platform_options["glance_api_process_name"]
            process_name pname
            script_name sname
	end

	monitoring_metric "glance-api-proc" do
            type "proc"
            proc_name "glance-api"
            proc_regex platform_options["glance_api_service"]

            alarms(:failure_min => 2.0)
	end

	# set up glance api monitoring (bytes/objects per tentant, etc)
	monitoring_metric "glance-api" do
	    type "pyscript"
	    script "glance_plugin.py"
	    options(
	        "Username" => node["glance"]["service_user"],
	        "Password" => node["glance"]["service_pass"],
	        "TenantName" => node["glance"]["service_tenant_name"],
	        "AuthURL" => ks_service_endpoint["uri"]
	    )
	end
end
