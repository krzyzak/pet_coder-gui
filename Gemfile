# frozen_string_literal: true

source "https://rubygems.org"

ruby file: ".ruby-version"

gem "gosu"

group :development, :test do
  gem "rspec"
end

group :development do
  gem "rubocop", require: false
  gem "rubocop-shopify", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-performance", require: false
end
