# Cookbook Name:: openstack-monitoring
# Recipe:: nova-api-os-compute
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

myname = "nova-api-os-compute"

if node.recipe?("nova::api-os-compute")
  platform_options = node["nova"]["platform"]
  nova_osapi_endpoint = get_bind_endpoint("nova", "api")

  # don't monitor the process if running under ssl
  # (indicates currently that apache is running the process)
  unless nova_osapi_endpoint["scheme"] == "https"
    monitoring_procmon myname do
      process_name platform_options["api_os_compute_procmatch"]
      script_name platform_options["api_os_compute_service"]
      http_check ({
        :host => nova_osapi_endpoint["host"],
        :port => nova_osapi_endpoint["port"]
      })
    end
  end

  monitoring_metric "#{myname}-proc" do
    type "proc"
    proc_name "nova-api-os-compute"
    proc_regex platform_options["api_os_compute_service"]
    alarms(:failure_min => 2.0)
  end
end
