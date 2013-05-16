# Cookbook Name:: openstack-monitoring
# Recipe:: swift-proxy-server
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

if node.recipe?("swift::proxy-server") or node[:recipes].include?("swift::proxy-server")
	swift_proxy_service = platform_options["service_prefix"] + "swift-proxy" + platform_options["service_suffix"]
	monitoring_procmon "swift-proxy" do
            process_name "python.*swift-proxy.*"
            script_name swift_proxy_service
            only_if "[ -e /etc/swift/proxy-server.conf ] && [ -e /etc/swift/object.ring.gz ]"
	end

	monitoring_metric "swift-proxy-proc" do
            type "proc"
            proc_name "swift-proxy"
            proc_regex "python.*swift-proxy.*"

            alarms(:failure_min => 1.0)
	end
end
