# Cookbook Name:: openstack-monitoring
# Recipe:: heat-api.rb
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
if node.recipe?("heat::heat-api")
  platform_options = node["heat"]["platform"]

  monit_procmon "heat-api" do
    process_name platform_options["api_procmatch"]
    script_name platform_options["api_service"]
  end

  monitoring_metric "heat-api-proc" do
    type "proc"
    proc_name "heat-api"
    proc_regex platform_options["api_service"]
    alarms(:failure_min => 2.0)
  end
end
