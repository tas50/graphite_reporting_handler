#
# Copyright Peter Donald
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


include_recipe 'chef_handler'


handler_file = 'chef-handler-graphite-reporting.rb'
handler_path = File.join(Chef::Config[:file_cache_path], handler_file)

cookbook_file handler_path do
  source handler_file
  if node['platform'] != 'windows'
    mode '0600'
  end
end

chef_handler 'GraphiteReportingHandler' do
  action :enable
  source handler_path
  arguments [
    :metric_prefix => node['graphite_reporting_handler']['metric_prefix'],
    :metric_key => node['graphite_reporting_handler']['metric_key'],
    :graphite_host => node['graphite_reporting_handler']['graphite_host'],
    :graphite_port => node['graphite_reporting_handler']['graphite_port'],
    :graphite_protocol => node['graphite_reporting_handler']['graphite_protocol']
  ]
end
