require 'fog'
require_relative 'yaml_config'

class Remote < OpenStruct
  attr_reader :connection

  def initialize(path)
    config      = YamlConfig.new path
    @connection = Fog::Storage.new(
      :provider                 => 'AWS',
      :aws_access_key_id        => config.key,
      :aws_secret_access_key    => config.secret
      )

    # Add attributes for key/values found in the config file

    super(YAML.load_file path)
  end
end
