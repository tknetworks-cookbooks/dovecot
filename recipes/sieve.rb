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
include_recipe 'dovecot::server'

case node['platform']
when 'debian'
  package 'dovecot-sieve' do
    notifies :restart, 'service[dovecot]'
    action :install
  end

  dovecot_conf 'sieve' do
    action :create
    priority 90
    notifies :restart, 'service[dovecot]'
  end

  if node['dovecot']['conf']['sieve']['global_path']
    template node['dovecot']['conf']['sieve']['global_path'] do
      owner node['dovecot']['conf']['sieve']['user']
      group node['dovecot']['conf']['sieve']['group']
      mode '0644'
      source 'default.sieve.erb'
      if node['dovecot']['conf_cookbook_by_name'].include?('default.sieve')
        cookbook node['dovecot']['conf_cookbook']
      end
    end
  end

  if node['dovecot']['conf']['sieve']['global_dir']
    directory node['dovecot']['conf']['sieve']['global_dir'] do
      owner node['dovecot']['conf']['sieve']['user']
      group node['dovecot']['conf']['sieve']['group']
      mode '0755'
    end
  end
end
