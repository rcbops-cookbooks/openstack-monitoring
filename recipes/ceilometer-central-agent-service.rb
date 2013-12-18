# Cookbook Name:: openstack-monitoring
# Recipe:: ceilometer-central-agent-service
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

if node.recipe?("ceilometer::ceilometer-central-agent")
  platform_options = node["ceilometer"]["platform"]
  service_name = platform_options["central_agent_service"]
  proc_name = platform_options["central_agent_procmatch"]

  monit_procmon "ceilometer-central-agent" do
    process_name proc_name
    script_name service_name
  end

  monitoring_metric "ceilometer-central-agent-proc" do
    type "proc"
    proc_name service_name
    proc_regex service_name
    alarms(:failure_min => 2.0)
  end
end
