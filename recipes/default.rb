#!/usr/bin/env ruby
#
# Installs & Configures Graphite Reporting Handler for Chef.
#   - Copies Ruby Module to Chef's Ruby Path.
#   - Adds Module as Chef Handler.
#
# Recipe:: default
# Cookbook:: graphite_reporting_handler
# Author:: Greg Albrecht (<gba@onbeep.com>)
# Copyright:: Copyright 2014 OnBeep, Inc.
# License:: Apache License, Version 2.0
# Source:: https://github.com/OnBeep/cookbook-graphite_reporting_handler
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
