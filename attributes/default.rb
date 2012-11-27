#
# Cookbook Name:: fisheye
# Attributes:: default 
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

default['fisheye']['version']='2.9.1'
default['fisheye']['parentdir']='/opt'

# This is what the Fisheye documentation refers to as the "<Fisheye home directory>"
default['fisheye']['homedir']="#{node['fisheye']['parentdir']}/fecru-#{node['fisheye']['version']}"
default['fisheye']['zipfile']="fisheye-#{node['fisheye']['version']}.zip"
default['fisheye']['url']="http://www.atlassian.com/software/fisheye/downloads/binary/#{node['fisheye']['zipfile']}"

# This is what the Fisheye documentation refers to as the FISHEYE_INST directory
default['fisheye']['instdir']='/var/fisheye-home'

# For Atlassian Crowd integration
default['fisheye']['crowd_sso']['sso_appname']='fisheye'
default['fisheye']['crowd_sso']['sso_password']='fisheye'
default['fisheye']['crowd_sso']['crowd_base_url']='http://localhost:8095/crowd/'
