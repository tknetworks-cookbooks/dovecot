#
# Author:: TANABE Ken-ichi (<nabeken@tknetworks.org>)
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
require 'spec_helper'

describe 'dovecot::conf_ssl' do
  include_context 'debian'

  let (:chef_run) {
    ChefSpec::Runner.new(step_into: %w{dovecot_conf}) do |node|
      set_node(node)
    end
  }

  let (:conf) {
    chef_run.find_resource('dovecot_conf', 'ssl')
  }

  before do
    chef_run.node.set['dovecot']['conf']['ssl'] = 'required'
    chef_run.converge('dovecot::conf_ssl')
  end

  it "configures ssl.conf" do
    expect(chef_run).to render_file("#{chef_run.node['dovecot']['dir']}/conf.d/10-ssl.conf")
    .with_content('ssl = required')

    expect(chef_run).to create_template("#{chef_run.node['dovecot']['dir']}/conf.d/10-ssl.conf")
    .with(
      user: 'root',
      group: 'root',
      mode: 0644
    )
  end

  it 'restart dovecot service' do
    expect(conf).to notify('service[dovecot]')
  end
end
