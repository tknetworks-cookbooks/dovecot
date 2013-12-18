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
require 'spec_helper'

describe 'dovecot::sieve' do
  include_context 'debian'

  let (:chef_run) {
    ChefSpec::Runner.new(step_into: %w{dovecot_conf}) do |node|
      set_node(node)
    end
  }

  let (:conf) {
    chef_run.find_resource('dovecot_conf', 'sieve')
  }

  context "global_path is nil" do
    before do
      chef_run.converge('dovecot::sieve')
    end

    it "configures sieve.conf" do
      [
        "sieve = ~/.dovecot.sieve",
        "sieve_dir = ~/sieve",
      ].each do |l|
        expect(chef_run).to render_file("#{chef_run.node['dovecot']['dir']}/conf.d/90-sieve.conf")
        .with_content(l)
      end
    end

    it 'restart dovecot service' do
      expect(conf).to notify('service[dovecot]')
    end
  end

  context "global_{path,dir} is set" do
    before do
      chef_run.node.set['dovecot']['conf']['sieve']['global_path'] = '/tmp/default.sieve'
      chef_run.node.set['dovecot']['conf']['sieve']['global_dir'] = '/tmp/sieve'
      chef_run.node.set['dovecot']['conf']['sieve']['user'] = 'user'
      chef_run.node.set['dovecot']['conf']['sieve']['group'] = 'group'
      chef_run.converge('dovecot::sieve')
    end

    it "configures sieve.conf" do
      f = "#{chef_run.node['dovecot']['dir']}/conf.d/90-sieve.conf"
      [
        "sieve = ~/.dovecot.sieve",
        "sieve_dir = ~/sieve",
        "sieve_default = /tmp/default.sieve",
        "sieve_global_dir = /tmp/sieve"
      ].each do |l|
        expect(chef_run).to render_file(f)
        .with_content(l)
        expect(chef_run).to create_template(f)
        .with(
          owner: 'root',
          group: 'root',
          mode: 0644
        )
      end
    end

    it "configures sieve scripts" do
      expect(chef_run).to create_template(chef_run.node['dovecot']['conf']['sieve']['global_path'])
      .with(
        user: 'user',
        group: 'group',
        mode: '0644'
      )

      expect(chef_run).to create_directory(chef_run.node['dovecot']['conf']['sieve']['global_dir'])
      .with(
        user: 'user',
        group: 'group',
        mode: '0755'
      )
    end
  end

end
