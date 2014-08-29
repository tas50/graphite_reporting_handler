#!/usr/bin/env ruby
#
# Attributes:: default
# Cookbook:: graphite_reporting_handler
# Author:: Greg Albrecht (<gba@onbeep.com>)
# Copyright:: Copyright 2014 OnBeep, Inc.
# License:: Apache License, Version 2.0
# Source:: https://github.com/onbeep-cookbooks/graphite_reporting_handler
#

default['graphite_reporting_handler']['graphite_host'] = 'localhost'
default['graphite_reporting_handler']['graphite_port'] = '2003'
default['graphite_reporting_handler']['graphite_protocol'] = 'tcp'

# Prepended to the metric_key below, useful for hostedgraphite.com's API Key:
default['graphite_reporting_handler']['metric_prefix'] = nil

# This returns something like: chef.runs._default.node.tacocopter_com
default['graphite_reporting_handler']['metric_key'] = [
  'chef',
  'runs',
  node.chef_environment,
  'node',
  (node['hostname'] || '').downcase
].join('.')
