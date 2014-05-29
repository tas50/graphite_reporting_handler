# graphite_reporting_handler Cookbook

## Description

A Chef Cookbook that installs & configures a report handler for sending Chef run
metrics to Graphite. If you have the [system_packages](https://github.com/finnlabs/ohai-system_packages/)
Ohai plugin installed, this handler will also send package metrics to Graphite.


## Requirements

The `chef_handler` Cookbook.


## Attributes

This cookbook uses the following attributes to configure how it is installed.

* `node['graphite_reporting_handler']['graphite_host']` - Host where Graphite's
Carbon daemon is accepting metrics. Default: `localhost`
* `node['graphite_reporting_handler']['graphite_port']` - Port where Graphite's Carbon
daemon is accepting metrics. Default: `2003`
* `node['graphite_reporting_handler']['graphite_protocol']` - Protocol for
communicating with Graphite's Carbon daemon. Default: `tcp`
* `node['graphite_reporting_handler']['metric_path']` - Metric path, or queue.
Default: `chef.#{node.chef_environment}.node.#{node['hostname']}`
* `node['graphite_reporting_handler']['metric_prefix']` - Prepended to the metric_path,
useful for [Hosted Graphite's](http://hostedgraphite.com) API Key. Default: `nil`


## Usage

1. Set Attributes for your Graphite Carbon host:

  ```json
  default_attributes(
    {'graphite_reporting_handler' => {'graphite_host' => 'metrics.tacocopter.com'}}
  )
  ```

2. Add the **graphite_reporting_handler** to your Run List:

  `run_list('recipe[graphite_reporting_handler]')`

3. Look at graphs, impress your friends, go home early?


## Credit & Inspiration
The original Graphite Reporting Handler was written by Ian Meyer, and
was converted into a Cookbook by Peter Donald, et al. The original Reporting Handler
was scrubbed of the *graphite-simple* Gem requirement by the team at Etsy. This
Cookbook was derived from these sources and adds UDP and metric_prefix support.


## Contributors
See CONTRIBUTORS.md


## Author
Greg Albrecht (<gba@onbeep.com>)


## License
Apache License, Version 2.0


## Copyright
Copyright 2014 OnBeep, Inc.


## Source
https://github.com/onbeep-cookbooks/graphite_reporting_handler
