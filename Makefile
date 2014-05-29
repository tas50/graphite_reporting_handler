# Makefile for graphite_reporting_handler Cookbook.
#
# Author:: Greg Albrecht <gba@onbeep.com>
# Copyright:: Copyright 2014 OnBeep, Inc.
# License:: Apache License, Version 2.0
# Source:: https://github.com/onbeep-cookbooks/graphite_reporting_handler
#


# Global/env vars:

.DEFAULT_GOAL := install

BUNDLE_CMD ?= ~/.rbenv/shims/bundle

BUNDLE_EXEC ?= bundle exec


# Target groups:

test: install foodcritic kitchen_test

install: $(BUNDLE_CMD) bundle_install

clean: kitchen_destroy

release: bump_version git_push_tags berks_upload


# Bundler itself:

$(BUNDLE_CMD):
	gem install bundler

bundle_install: $(BUNDLE_CMD)
	bundle install


# Post bundler targets:

kitchen_converge:
	$(BUNDLE_EXEC) kitchen converge

kitchen_destroy:
	$(BUNDLE_EXEC) kitchen destroy

kitchen_verify:
	$(BUNDLE_EXEC) kitchen verify

kitchen_test:
	$(BUNDLE_EXEC) kitchen test

foodcritic:
	$(BUNDLE_EXEC) foodcritic .

bump_version:
	$(BUNDLE_EXEC) scmversion bump auto --default patch

berks_install: bundle_install
	$(BUNDLE_EXEC) berks install

berks_upload: berks_install
	$(BUNDLE_EXEC) berks upload

git_push_tags:
	git push origin --tags

# Knife targets:

publish:
	knife cookbook site share graphite_reporting_handler Networking -o ..
