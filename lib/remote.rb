require 'fog'
require_relative 'yaml_config'

# Public: Wrapper class around Fog gem S3 functionality.
class Remote < OpenStruct
  attr_reader :connection

  def initialize(path, data_store = Fog::Storage)
    config      = YamlConfig.new path

    @connection = data_store.new(
      provider:              'AWS',
      aws_access_key_id:     config.key,
      aws_secret_access_key: config.secret
    )

    # Add attributes for key/values found in the config file
    super(YAML.load_file path)
  end

  def latest_file_name(pattern)
    file_name latest_file(pattern)
  end

  def read_latest_file(pattern)
    @connection.directories.get(bucket).files.get(latest_file(pattern).key) do |chunk, remaining, total|
      yield chunk, remaining, total
    end
  end

  private

  # Internal: Build a list of all files in the bucket; cache the results
  def file_list
    return @file_list_cache unless @file_list_cache.nil?

    files = @connection.directories.get(bucket).files
    list  = []
    list << files

    while files.length == 1000
      files = @connection.directories.get(bucket).files.all( :marker => files.last.key )
      list << files
    end

    @file_list_cache = list.flatten
    @file_list_cache
  end

  def file_name(file)
    file.key.scan(/[^\/$]+$/).first
  end

  def latest_file(pattern)
    file_list.select { |f| f.key =~ pattern }.sort { |a,b| b.last_modified <=> a.last_modified }.first
  end
end
