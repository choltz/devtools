require 'fog'
require_relative 'yaml_config'

# Public: Wrapper class around Fog gem S3 functionality.
class Remote < OpenStruct
  attr_reader :connection

  def initialize(path)
    config      = YamlConfig.new path

    @connection = Fog::Storage.new(
      provider:              'AWS',
      aws_access_key_id:     config.key,
      aws_secret_access_key: config.secret
    )

    # Add attributes for key/values found in the config file
    super(YAML.load_file path)
  end

  def latest_file_name
    file_name latest_file
  end

  def read_latest_file
    file_list.get(latest_file.key) do |chunk, remaining, total|
      yield chunk, remaining, total
    end
  end

  private

  def file_list
    @connection.directories.get(bucket).files
  end

  def file_name(file)
    file.key.scan(/[^\/$]+$/).first
  end

  def latest_file
    file_list.sort { |a,b| b.last_modified <=> a.last_modified }.first
  end
end
