#
# Cookbook Name:: pdsh
# Recipe:: monitor
#
# Copyright 2012, DreamHost.com
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
#

package 'pdsh' do
  action :upgrade
end

mons = search(:node, "run_list:recipe\[ceph\:\:mon\] AND chef_environment:#{node.chef_environment}")

mon_genders = String.new
mons.each do |mon|
  new = mon_genders << mon.hostname << ','
  mon_genders = new
end

osds = search(:node, "run_list:recipe\[ceph\:\:osd\] AND chef_environment:#{node.chef_environment}")

osd_genders = String.new
osds.each do |osd|
  new = osd_genders << osd.hostname << ','
  osd_genders = new
end

rgws = search(:node, "role:ceph-rgw AND chef_environment:#{node.chef_environment}")

rgw_genders = String.new
rgws.each do |rgw|
  new = rgw_genders << rgw.hostname << ','
  rgw_genders = new
end

oss_servers = search(:node, "role:ceph-oss AND chef_environment:#{node.chef_environment}")

oss_genders = String.new
oss_servers.each do |oss|
  new = oss_genders << oss.hostname << ','
  oss_genders = new
end

template "/etc/genders" do
  source "genders.erb"
  user "root"
  group "root"
  mode 0644
  variables({
    :mons => mon_genders[0..-2],
    :osds => osd_genders[0..-2],
    :rgws => rgw_genders[0..-2],
    :oss => oss_genders[0..-2]
  })
end
