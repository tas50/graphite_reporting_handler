#!/usr/bin/env ruby
# Graphite Reporting Handler for Chef - Sends chef-client run metrics to Graphite.
#
# Inspired by:
#   - Etsy's Graphite Chef Handler: https://github.com/etsy/chef-handlers/blob/master/graphite.rb
#   - Ian Meyer's Graphite Chef Handler: https://github.com/imeyer/chef-handler-graphite
#   - Peter Donald's Graphite Handler Cookbook: https://github.com/realityforge/chef-graphite_handler
#
# Author:: Greg Albrecht (<gba@onbeep.com>)
# Copyright:: Copyright 2014 OnBeep, Inc.
# License:: Apache License, Version 2.0
# Source:: https://github.com/onbeep-cookbooks/graphite_reporting_handler
#

require 'chef'
require 'chef/handler'
require 'socket'

class GraphiteReportingHandler < Chef::Handler
  attr_writer :metric_prefix, :metric_key, :graphite_host, :graphite_port, :graphite_protocol

  def initialize(options = {})
    @metric_prefix = options[:metric_prefix] ? options[:metric_prefix] : nil
    @metric_key = options[:metric_key] ? options[:metric_key] : 'chef.runs'
    @graphite_host = options[:graphite_host] ? options[:graphite_host] : 'localhost'
    @graphite_port = options[:graphite_port] ? options[:graphite_port] : '2003'
    @graphite_protocol = options[:graphite_protocol] ? options[:graphite_protocol] : 'tcp'
  end

  def report
    Chef::Log.debug('GraphiteReportingHandler loaded as a Chef Handler.')

    metric_lines = []
    time = Time.now
    metrics = {}

    if run_status.respond_to?(:updated_resources)
      metrics[:updated_resources] = run_status.updated_resources.length
    end

    if run_status.respond_to?(:all_resources)
      metrics[:all_resources] = run_status.all_resources.length
    end

    metrics[:elapsed_time] = run_status.elapsed_time
    metrics[:success] = run_status.success? ? 1 : 0
    metrics[:fail] = run_status.success? ? 0 : 1

    # Graph metrics from the Ohai system-packages plugin:
    #   - https://github.com/finnlabs/ohai-system_packages/
    if node.key?('system_packages')
      node['system_packages'].each do |k, v|
        metrics[k, 'packages'.join('_')] = v.size if v && v.respond_to?(:size)
      end
    end

    metrics.each do |metric, value|
      metric_queue = if @metric_prefix
        [@metric_prefix, @metric_key, metric]
      else
        [@metric_key, metric]
      end.join('.')

      metric_line = [metric_queue, value, time.to_i].join(' ')
      metric_lines << metric_line

      Chef::Log.debug("GraphiteReportingHandler metric: #{metric_line}")
    end

    begin
      case @graphite_protocol.downcase
      when 'tcp'
        s = TCPSocket.new(@graphite_host, @graphite_port)
        s.write(metric_lines.join("\n") + "\n")
        s.close
      when 'udp'
        s = UDPSocket.new
        s.send(metric_lines.join("\n") + "\n", 0, @graphite_host, @graphite_port)
        s.close
      end
    rescue => e
      Chef::Log.error("GraphiteReportingHandler error reporting: #{e}")
    end
  end
end
