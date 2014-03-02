require 'rubygems'
require 'bundler/setup'
require 'progressbar'
require 'debugger'
require_relative "../remote"

class Pull
  def initialize
    # Connect to S3
    @s3_connection = Remote.new 'config/s3.yml'
    @bucket        = @s3_connection.bucket
  end

  def call
    files       = @s3_connection.directories.get( @bucket ).files
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
  end
end

Pull.new.call
