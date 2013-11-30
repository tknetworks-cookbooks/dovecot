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

describe 'dovecot::ldap' do
  include_context 'debian'

  let (:chef_run) {
    ChefSpec::Runner.new() do |node|
      set_node(node)
    end
  }

  let (:package) {
    chef_run.package('dovecot-ldap')
  }

  before do
    chef_run.converge('dovecot::ldap')
  end

  it "installs dovecot-ldap package" do
    expect(chef_run).to install_package "dovecot-ldap"
  end

  it 'restart dovecot service' do
    expect(package).to notify('service[dovecot]').to(:restart)
  end
end
