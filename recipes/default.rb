# Cookbook Name:: openstack-monitoring
# Recipe:: default
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
include_recipe "openstack-monitoring::mysql-server"
include_recipe "openstack-monitoring::rabbitmq-server"
include_recipe "openstack-monitoring::keystone"
include_recipe "openstack-monitoring::libvirt"
include_recipe "openstack-monitoring::glance-api"
include_recipe "openstack-monitoring::glance-registry"
include_recipe "openstack-monitoring::nova-api-ec2"
include_recipe "openstack-monitoring::nova-api-metadata"
include_recipe "openstack-monitoring::nova-api-os-compute"
include_recipe "openstack-monitoring::nova-api-os-volume"
include_recipe "openstack-monitoring::nova-cert"
include_recipe "openstack-monitoring::nova-compute"
include_recipe "openstack-monitoring::nova-conductor"
include_recipe "openstack-monitoring::nova-network"
include_recipe "openstack-monitoring::nova-scheduler"
include_recipe "openstack-monitoring::nova-setup"
include_recipe "openstack-monitoring::nova-vncproxy"
include_recipe "openstack-monitoring::cinder-api"
include_recipe "openstack-monitoring::cinder-scheduler"
include_recipe "openstack-monitoring::cinder-volume"
include_recipe "openstack-monitoring::haproxy"
include_recipe "openstack-monitoring::swift-account-server"
include_recipe "openstack-monitoring::swift-management-server"
include_recipe "openstack-monitoring::swift-rsync"
include_recipe "openstack-monitoring::swift-common"
include_recipe "openstack-monitoring::swift-object-server"
include_recipe "openstack-monitoring::swift-container-server"
include_recipe "openstack-monitoring::swift-proxy-server"
