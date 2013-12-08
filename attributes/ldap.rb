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
include_attribute 'dovecot::default'

default['dovecot']['ldap']['uris'] = []
default['dovecot']['ldap']['tls'] = false
default['dovecot']['ldap']['auth_bind'] = true
default['dovecot']['ldap']['ldap_version'] = 3
default['dovecot']['ldap']['base'] = nil
default['dovecot']['ldap']['scope'] = "subtree"
default['dovecot']['ldap']['user_attrs'] = "homeDirectory=home,uidNumber=uid,gidNumber=gid"
default['dovecot']['ldap']['user_filter'] = "(&(objectClass=posixAccount)(uid=%u))"
default['dovecot']['ldap']['pass_attrs'] = "uid=user,userPassword=password"
default['dovecot']['ldap']['pass_filter'] = "(&(objectClass=posixAccount)(uid=%u))"
