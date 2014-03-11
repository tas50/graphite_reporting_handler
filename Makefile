# Makefile for graphite_reporting_handler Cookbook.
#
# Author:: Greg Albrecht <gba@onbeep.com>
# Copyright:: Copyright 2014 OnBeep, Inc.
# License:: Apache License, Version 2.0
# Source:: https://github.com/OnBeep/cookbook-graphite_reporting_handler
#


.DEFAULT_GOAL := install


test: install kitchen_test

install: install_bundle bundle_install berks_install vagrant_plugins

update: bundle_update berks_update

destroy: vagrant_destroy kitchen_destroy


install_bundle:
	gem install bundle

bundle_install:
	bundle install

bundle_update:
	bundle update

berks_install:
	berks install

berks_update:
	berks update

vagrant_up:
	vagrant up

vagrant_provision:
	vagrant provision

vagrant_destroy:
	vagrant destroy -f

vagrant_plugins: vagrant_plugin_omnibus vagrant_plugin_berkshelf vagrant_plugin_vbguest

vagrant_plugin_omnibus:
	vagrant plugin install vagrant-omnibus

vagrant_plugin_berkshelf:
	vagrant plugin install --plugin-version 3.0.0.beta5 berkshelf
	vagrant plugin install --plugin-version 1.4.0.dev1 vagrant-berkshelf

vagrant_plugin_vbguest:
	vagrant plugin install vagrant-vbguest

kitchen_converge:
	kitchen converge

kitchen_destroy:
	kitchen destroy

kitchen_setup:
	kitchen setup

kitchen_verify:
	kitchen verify

kitchen_list:
	kitchen list

kitchen_test:
	kitchen test

guard_init:
	guard init

guard:
	guard

foodcritic:
	foodcritic .
