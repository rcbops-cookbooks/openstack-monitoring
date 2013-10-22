# Cookbook Name:: openstack-monitoring
# Recipe:: nova-api-ec2
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

myname = "nova-api-ec2"

if node.recipe?("nova::api-ec2")
  platform_options = node["nova"]["platform"]
  nova_ec2_endpoint = get_bind_endpoint("nova", "ec2-public")

  # don't monitor the process if running under ssl
  # (indicates currently that apache is running the process)
  unless nova_ec2_endpoint["scheme"] == "https"

    # on redhat, os-compute, ec2, and metadata apis all run under a single
    # nova-api process.  if we've already added a configuration to monitor
    # that single process, don't add another one from this recipe.
    # TODO(brett): health-check all the tcp ports (8773..8775 iirc)
    if platform_family?('rhel')
      if node.recipe?('openstack-monitoring::nova-api-os-compute')
        # monitoring_procman and monit_procman LWRPs do not have a
        # 'remove' action; delete the file if it exists. 
        file "/etc/monit.d/#{myname}.conf" do
          action :delete
        end
        return  # get out of here
      end
    end

    monitoring_procmon myname do
      process_name platform_options["api_ec2_procmatch"]
      script_name platform_options["api_ec2_service"]
    end

    monitoring_metric "#{myname}-proc" do
      type "proc"
      proc_name "nova-api-ec2"
      proc_regex platform_options["api_ec2_service"]
      alarms(:failure_min => 2.0)
    end

  end
end
