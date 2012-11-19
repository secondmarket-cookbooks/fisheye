#
# Cookbook Name:: fisheye
# Recipe:: server
#
# Copyright 2012, SecondMarket Labs, LLC.
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

include_recipe "java::oracle"

package "unzip" do
  action :install
end

execute "unzip-fisheye" do
  cwd node['fisheye']['parentdir']
  command "unzip #{Chef::Config[:file_cache_path]}/#{node['fisheye']['zipfile']}"
  action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['fisheye']['zipfile']}" do
  source node['fisheye']['url']
  action :nothing
  notifies :run, "execute[unzip-fisheye]", :immediately
end

http_request "HEAD #{node['fisheye']['url']}" do
  message ""
  url node['fisheye']['url']
  action :head
  if File.exists?("#{Chef::Config[:file_cache_path]}/#{node['fisheye']['zipfile']}")
    headers "If-Modified-Since" => File.mtime("#{Chef::Config[:file_cache_path]}/#{node['fisheye']['zipfile']}").httpdate
  end
  notifies :create, resources(:remote_file => "#{Chef::Config[:file_cache_path]}/#{node['fisheye']['zipfile']}"), :immediately
end

user "fisheye" do
  comment "Atlassian FishEye"
  home node['fisheye']['instdir']
  system true
  action :create
end

directory node['fisheye']['instdir'] do
  owner "fisheye"
  group "fisheye"
  mode 00755
  action :create
end

file "#{node['fisheye']['homedir']}/nohup.out" do
  owner "fisheye"
  group "fisheye"
  mode  00644
  action :create_if_missing
end

%w{cache data log tmp}.each do |d|
  directory "#{node['fisheye']['homedir']}/var/#{d}" do
    owner "fisheye"
    group "fisheye"
    mode 00755
    action :create
  end
end

file "/etc/profile.d/fisheye.sh" do
  owner "root"
  group "root"
  mode 00755
  action :create
  content "export FISHEYE_INST=#{node['fisheye']['instdir']}"
end

template "/etc/init.d/fisheye" do
  source "fisheye.init.erb"
  owner "root"
  group "root"
  mode 00755
  variables(
    :fisheye_base => node['fisheye']['homedir']
  )
  action :create
end

service "fisheye" do
  action :enable
end

execute "copy-basic-config-to-fisheye-inst" do
  command "cp #{node['fisheye']['homedir']}/config.xml #{node['fisheye']['instdir']}"
  not_if { ::File.exists?("#{node['fisheye']['instdir']}/config.xml") }
end

file "#{node['fisheye']['instdir']}/config.xml" do
  owner "fisheye"
  group "fisheye"
  mode  00644
  action :create
end

service "fisheye" do
  action :start
end
