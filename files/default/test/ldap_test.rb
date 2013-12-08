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
require 'minitest/spec'

describe_recipe 'dovecot::ldap' do
  it "installs dovecot package" do
    package("dovecot-ldap").must_be_installed
  end

  it "configures dovecot-ldap" do
    [
      "uris = ldaps://ldap.example.org",
      "tls = no",
      "tls_ca_cert_file = /etc/ssl/hoge.pem",
      "auth_bind = yes",
      "ldap_version = 3",
      "base = dc=mail, dc=example, dc=org",
      "scope = subtree",
      "user_attrs = homeDirectory=home,uidNumber=uid,gidNumber=gid",
      "user_filter = (&(objectClass=posixAccount)(uid=%u))",
      "pass_attrs = uid=user,userPassword=password",
      "pass_filter = (&(objectClass=posixAccount)(uid=%u))",
    ].each do |l|
      file("#{node['dovecot']['dir']}/dovecot-ldap.conf.ext")
      .must_include(l)
    end
  end
end
