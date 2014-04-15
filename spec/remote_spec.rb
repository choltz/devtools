require 'spec_helper'
require 'ostruct'

describe Remote do
  it "initializes it's connection with a connection path" do
    remote = Remote.new "#{Dir.pwd}/spec/data/test_s3.yml"
    expect(remote.connection.class).to eq Fog::Storage::AWS::Real
  end

  it 'returns the latest file in the folder' do
    remote = Remote.new "#{Dir.pwd}/spec/data/test_s3.yml"
    remote.stub(:latest_file) { OpenStruct.new :key => '/some_path/file1'}
    expect(remote.latest_file_name).to eq 'file1'
  end

  it 'reads a stream of the latest file and performs the block operation provided' do
    remote = Remote.new "#{Dir.pwd}/spec/data/test_s3.yml"

    # Note: I really don't like how much one needs to know about th internals of
    # remote.read_latest_file. This is an example of mock fagility.
    expect(remote).to receive(:file_list) { FileList.new }
    expect(remote).to receive(:latest_file) { OpenStruct.new key: 'file1' }
    remote.read_latest_file do  |chunk, remaining, total|
    end
  end

  private

  # Internal: mock object to mimic the fog file list
  class FileList
    def get(latest_file)
      yield
    end

    def sort
      []
    end
  end
end
