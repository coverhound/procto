#!/bin/sh -

ruby --version

# Install gems at runtime to avoid build-time gemspec issues
echo "Installing gems..."
bundle config set --local path '/usr/local/bundle'
bundle install --jobs 4 --retry 3

bundle exec rake
