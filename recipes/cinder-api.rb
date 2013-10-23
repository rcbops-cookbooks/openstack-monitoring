# Cookbook Name:: openstack-monitoring
# Recipe:: cinder-api
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

if node.recipe?("cinder::cinder-api")
  platform_options = node["cinder"]["platform"]
  volume_endpoint = get_bind_endpoint("cinder", "api")

  # don't monitor the process if it's using ssl
  # (which currently indicates that apache is running the process)
  unless volume_endpoint["scheme"] == "https"
    monitoring_procmon "cinder-api" do
      process_name platform_options["cinder_api_procmatch"]
      script_name platform_options["cinder_api_service"]
      http_check({
        :host => volume_endpoint["host"],
        :port => volume_endpoint["port"]
      })
    end
  end

  monitoring_metric "cinder-api-proc" do
    type "proc"
    proc_name "cinder-api"
    proc_regex platform_options["cinder_api_service"]
    alarms(:failure_min => 2.0)
  end
end
