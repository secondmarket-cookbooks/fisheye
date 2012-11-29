#
# Cookbook Name:: fisheye
# Recipe:: local_database
#
# Copyright 2012, SecondMarket Labs, LLC
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe "postgresql::server"
include_recipe "database::postgresql"

# randomly generate Jira PostgreSQL password
node.set_unless['fisheye']['local_database']['password'] = secure_password
node.save unless Chef::Config['solo']

# Assume we're running the crowd server locally
postgresql_connection_info = {:host => "localhost", :username => "postgres", :password => node['postgresql']['password']['postgres']}

postgresql_database_user 'fisheye' do
  connection postgresql_connection_info
  password node['fisheye']['local_database']['password']
  action :create
end

postgresql_database 'fisheye' do
  connection postgresql_connection_info
  encoding 'UTF-8'
  owner 'postgres'
  action :create
end

postgresql_database_user 'fisheye' do
  connection postgresql_connection_info
  database_name 'fisheye'
  privileges [:all]
  action :grant
end

#directory "#{node['fisheye']['instdir']}/dbmig" do
#  owner "fisheye"
#  group "fisheye"
#  mode 0700
#  action :create
#end

# I tried to make this work in Chef, but ran up against "STDERR: standard in must be a tty" when importing. Too bad
#execute "dump-fisheye-hsqldb-to-migrate" do
# command "#{node['fisheye']['homedir']}/bin/fisheyectl.sh backup -q -f #{node['fisheye']['instdir']}/dbmig/chef-local-database-migration.zip"
# user "fisheye"
# creates "#{node['fisheye']['instdir']}/dbmig/chef-local-database-migration.zip"
# action :run
# notifies :run, "execute[switch-fisheye-to-postgresql]", :immediately
#end

#execute "switch-fisheye-to-postgresql" do
#  command "/sbin/service fisheye stop && #{node['fisheye']['homedir']}/bin/fisheyectl.sh restore --sql --file #{node['fisheye']['instdir']}/dbmig/chef-local-database-migration.zip --dbtype postgresql --jdbcurl jdbc:postgresql://localhost/fisheye --username fisheye --password #{node['fisheye']['local_database']['password']}"
#  user "fisheye"
#  action :nothing
#  notifies :restart, "service[fisheye]", :immediately
#end
