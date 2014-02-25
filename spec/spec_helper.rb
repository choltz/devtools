require 'simplecov'
SimpleCov.start

require_relative "../lib/yaml_config"

RSpec.configure do |config|
  config.color_enabled = true
  config.mock_with :rspec
end
