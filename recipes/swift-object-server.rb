# Cookbook Name:: openstack-monitoring
# Recipe:: swift-object-server
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

if node.recipe?("swift::object-server")
  %w{swift-object swift-object-auditor swift-object-updater swift-object-replicator}.each do |svc|
    platform_options = node["swift"]["platform"]
    service_name = platform_options["service_prefix"] + svc + platform_options["service_suffix"]
    monitoring_procmon svc do
      process_name '^((/usr/bin/)?python\d? )?(/usr/bin/)?'+svc+'\b'
      script_name service_name
      only_if "[ -e /etc/swift/object-server.conf ] && [ -e /etc/swift/object.ring.gz ]"
    end

    monitoring_metric "#{svc}-proc" do
      type "proc"
      proc_name svc
      proc_regex '^((/usr/bin/)?python\d? )?(/usr/bin/)?'+svc+'\b'
      alarms(:failure_min => 1.0)
    end
  end
end
