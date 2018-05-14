# Taken from https://github.com/chef-cookbooks/ufw/pull/14/files to support
# managing /etc/default/ufw. Original file below
#
# Author:: rchekaluk
# Cookbook Name:: ufw
# Recipe:: configure
#
# Copyright 2015, Opscode, Inc
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

node['firewall']['configuration'].each_pair do |key,value|

  bash "Assign ufw configuration value" do
    code <<-EOH
      if [ -n "`egrep '^[[:space:]]*#{key}=' #{node['firewall']['configuration_file']}`" ]; then
        sed -i '/^[[:space:]]*#{key}=/ s|=.*$|="#{value}"|' #{node['firewall']['configuration_file']}
      else
        echo '#{key}="#{value}"' >> #{node['firewall']['configuration_file']}
      fi
    EOH
    notifies :restart, 'service[ufw]', :delayed
    not_if "egrep \"^[[:space:]]*#{key}=['\\\"]{,1}#{value}['\\\"]{,1}\" #{node['firewall']['configuration_file']}"

  end unless key.nil? || key == ''

end
