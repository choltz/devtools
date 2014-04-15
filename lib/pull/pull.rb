require          'rubygems'
require          'bundler/setup'
require          'debugger'
require_relative '../remote'
require_relative '../progress'

# Public: Download the latest db image from S3 and store it locally
class Pull
  def initialize
    @remote   = Remote.new 'config/s3.yml'
    @bucket   = @remote.bucket
    @progress = Progress.new
  end

  def call
    progress          = ProgressBar.new 'Downloading', 100
    progress.bar_mark = '='

    # Stream the remote file and write locally in chunks
    File.open("backups/#{@remote.latest_file_name}", 'w') do |local_file|
      @remote.read_latest_file do |chunk, remaining, total|
        local_file.write chunk

        percent = (100 - (remaining.to_f / total.to_f * 100))
        progress.set(percent)
      end
    end

    puts '' # move to the next line in the terminal
  end
end
