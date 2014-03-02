require "spec_helper"

describe Remote do
  it "initializes it's connection with a connection path" do
    remote = Remote.new "#{Dir.pwd}/spec/data/test_s3.yml"
    expect(remote.connection.class).to eq Fog::Storage::AWS::Real
  end
end
