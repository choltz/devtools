require 'rubygems'
require 'bundler/setup'
require 'fog'
require 'progressbar'
require 'yaml'

# Connect to S3
config     = YAML.load_file 'config/s3.yml'
connection = Fog::Storage.new(
  :provider                 => 'AWS',
  :aws_access_key_id        => config['key'],
  :aws_secret_access_key    => config['secret']
)

# find the latest file in the bucket
files       = connection.directories.get( config["bucket"] ).files
latest_file = files.sort{|a,b| b.last_modified <=> a.last_modified}.first
file_name   = latest_file.key.scan(/[^\/$]+$/).first

# configure the progress bar
progress          = ProgressBar.new 'Downloading', 100
progress.bar_mark = '='

# Stream the S3 file and write locally in chunks
File.open("backups/#{file_name}", 'w') do |local_file|
  files.get(latest_file.key) do |chunk, remaining, total|
    local_file.write chunk

    percent = (100 - (remaining.to_f / total.to_f * 100))

    progress.set(percent)
  end
end

puts "" # move to the next line in the terminal
