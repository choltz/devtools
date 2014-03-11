require 'simplecov'
SimpleCov.start

require_relative '../lib/yaml_config'
require_relative '../lib/remote'
require_relative '../lib/progress'
require_relative '../lib/db_pull/db_pull.rb'

RSpec.configure do |config|
  config.color_enabled = true
  config.mock_with :rspec
end
