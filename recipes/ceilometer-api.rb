# Cookbook Name:: openstack-monitoring
# Recipe:: ceilometer-api
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

if node.recipe?("ceilometer::ceilometer-api")
  platform_options = node["ceilometer"]["platform"]
  service_name = platform_options["api_service"]
  endpoint = get_bind_endpoint("ceilometer", "api")

  # don't monitor the process if it's using ssl
  # (which currently indicates that apache is running the process)
  unless endpoint["scheme"] == "https"
    monitoring_procmon "#{service_name}" do
      process_name "#{service_name}\b"
      script_name service_name
      http_check({
        :host => endpoint["host"],
        :port => endpoint["port"]
      })
    end
  end

  monitoring_metric "#{service_name}-proc" do
    type "proc"
    proc_name "#{service_name}"
    proc_regex "#{service_name}\b"
    alarms(:failure_min => 2.0)
  end
end
