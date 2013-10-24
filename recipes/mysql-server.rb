# Cookbook Name:: openstack-monitoring
# Recipe:: mysql-openstack
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
include_recipe "osops-utils"

# monitoring setup..
if node.recipe?("mysql-openstack::server")
  platform_options = node["mysql"]["platform"]

  monitoring_procmon "mysqld" do
    process_name platform_options["mysql_procmatch"]
    script_name platform_options["mysql_service"]
  end

  # This is going to fail for an external database server...
  monitoring_metric "mysqld-proc" do
    type "proc"
    proc_name "mysqld"
    proc_regex platform_options["mysql_procmatch"]
    alarms(:failure_min => 1.0)
  end

  mysql_info = get_bind_endpoint("mysql", "db")
  monitoring_metric "mysql" do
    type "mysql"
    host mysql_info["host"]
    user "root"
    password node["mysql"]["server_root_password"]
    port mysql_info["port"]
    alarms(
      "max_connections" => {
        :warning_max => node["mysql"]["tunable"]["max_connections"].to_i * 0.8,
        :failure_max => node["mysql"]["tunable"]["max_connections"].to_i * 0.9
      }
    )
  end
end
