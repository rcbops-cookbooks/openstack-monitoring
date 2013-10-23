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
if node.recipe?("glance::api")
  platform_options = node["glance"]["platform"]
  ks_service_endpoint = get_access_endpoint("keystone-api", "keystone", "service-api")
  glance_api_endpoint = get_bind_endpoint("glance", "api")
  glance_settings = get_settings_by_role("glance-setup", "glance")

  unless glance_api_endpoint["scheme"] == "https"
    monitoring_procmon "glance-api" do
      process_name platform_options["glance_api_procmatch"]
      script_name platform_options["glance_api_service"]
      http_check({
        :host => glance_api_endpoint["host"],
        :port => glance_api_endpoint["port"]
      })
    end
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
      "Username" => glance_settings["service_user"],
      "Password" => glance_settings["service_pass"],
      "TenantName" => glance_settings["service_tenant_name"],
      "AuthURL" => ks_service_endpoint["uri"]
    )
  end
end
