#
# Author:: Ken-ichi TANABE (<nabeken@tknetworks.org>)
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
# This LWRP supports whyrun mode
def whyrun_supported?
  true
end

action :create do
  case node['platform']
  when 'debian'
    res = template "#{node['dovecot']['dir']}/conf.d/#{new_resource.priority}-#{new_resource.name}.conf" do
      owner 'root'
      group 'root'
      mode 0644
      source "conf.d/#{new_resource.name}.conf.erb"
      cookbook node['dovecot']['conf_cookbook']
    end
  end
  res.run_action(:create)
  new_resource.updated_by_last_action(res.updated_by_last_action?)
end

action :remove do
  case node['platform']
  when 'debian'
    res = file "#{node['dovecot']['dir']}/conf.d/#{new_resource.priority}-#{new_resource.name}.conf" do
      action :delete
    end
  end
  res.run_action(:delete)
  new_resource.updated_by_last_action(res.updated_by_last_action?)
end
