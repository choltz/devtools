require 'spec_helper'
require 'ostruct'

describe Remote do
  it "initializes it's connection with a connection path" do
    remote = Remote.new "#{Dir.pwd}/spec/data/test_s3.yml"
    expect(remote.connection.class).to eq Fog::Storage::AWS::Real
  end

  it 'returns the latest file in the folder' do
    remote = Remote.new "#{Dir.pwd}/spec/data/test_s3.yml", MockStore
    expect(remote.latest_file_name).to eq 'file1'
  end

  # Mock object to help isolate Remote class tests. I have mixed feelings here
  # due to the argument to not mock what you don't own. I don't maintain the
  # Fog gem, so I certainly don't own in.
  #
  # However, this is a small app and it will never become large - keeping track
  # of this dependency is pretty easy. The proper way to address this, provided
  # I insist on mocking the library, is to include acceptance tests that don't
  # mock. That should capture library changes and raise errors and shine a
  # light on the tests in this file.
  class MockStore
    def initialize(*args)
    end

    def directories
      MockDirectory.new
    end
  end

  # Internal: mock directory returned from MockStor class.
  class MockDirectory
    def get(bucket)
      file1 = OpenStruct.new key: 'file1', last_modified: Date.today
      file2 = OpenStruct.new key: 'file2', last_modified: Date.today - 10
      OpenStruct.new :files => [file1, file2]
    end
  end
end
