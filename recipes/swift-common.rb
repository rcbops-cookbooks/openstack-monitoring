# Cookbook Name:: openstack-monitoring
# Recipe:: swift-common
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

if node.recipe?("swift::common")
  platform_options = node["swift"]["platform"]
  monitoring_metric "swift-common-stats" do
    type "pyscript"
    script "swift_stats.py"
    alarms(
      "Plugin_unmounts" => {
        "Type_gauge" => {
          :data_source => "value",
          :failure_max => 0.0
        }
      }
    )
  end
end
