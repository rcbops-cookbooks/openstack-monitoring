# Cookbook Name:: openstack-monitoring
# Recipe:: nova-setup
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

if node.recipe?("nova::nova-setup")
  ks_service_endpoint = get_access_endpoint("keystone-api", "keystone", "service-api")
  keystone = get_settings_by_role("keystone-setup", "keystone")
  keystone_admin_user = keystone["admin_user"]
  keystone_admin_password = keystone["users"][keystone_admin_user]["password"]
  keystone_admin_tenant = keystone["users"][keystone_admin_user]["default_tenant"]
  monitoring_metric "nova-plugin" do
    type "pyscript"
    script "nova_plugin.py"
    options(
      "Username" => keystone_admin_user,
      "Password" => keystone_admin_password,
      "TenantName" => keystone_admin_tenant,
      "AuthURL" => ks_service_endpoint["uri"])
  end
end
