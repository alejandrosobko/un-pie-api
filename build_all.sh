#!/usr/bin/env sh

set -e
bundle install
bin/rake db:create
bin/rake db:migrate RAILS_ENV=test

bundle exec rspec
