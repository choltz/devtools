require "spec_helper"

describe YamlConfig do
  it "loads up the config file specified" do
    # This shouldn't error, no need for an assertion
    YamlConfig.new "#{Dir.pwd}/spec/data/config_test.yml"
  end

  it "makes config values available as properties" do
    config = YamlConfig.new "#{Dir.pwd}/spec/data/config_test.yml"
    expect(config.test1).to eq "buh1"
    expect(config.test2).to eq "buh2"
    expect(config.test3).to eq "buh3"
    expect(config.num1).to  eq 1
    expect(config.num2).to  eq 2
  end

  it "doesn't discriminate symbol vs string access" do
    config = YamlConfig.new "#{Dir.pwd}/spec/data/config_test2.yml"
    expect(config.string_key).to eq "string"
    expect(config.symbol_key).to eq "symbol"
  end

  it "supports nested yaml structures"
end
