#!/usr/bin/env ruby
# Graphite Chef Handler.
#
# Inspired by:
#   - Etsy's Graphite Chef Handler: https://github.com/etsy/chef-handlers/blob/master/graphite.rb
#   - Ian Meyer's Graphite Chef Handler: https://github.com/imeyer/chef-handler-graphite
#
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
    Chef::Log.debug('GraphiteHandler loaded as a Chef Handler.')

    metric_lines = []
    time = Time.now
    metrics = Hash.new

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
    if node.has_key?('system_packages')
      node['system_packages'].each do |k, v|
        metrics[k, 'packages'.join('_')] = v.size if v and v.respond_to?(:size)
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

      Chef::Log.debug("GraphiteHandler metric: #{metric_line}")
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
      Chef::Log.error("GraphiteHandler error reporting: #{e}")
    end
  end
end
