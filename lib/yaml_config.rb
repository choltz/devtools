require "yaml"
require "ostruct"

# Public: Decorator to make yaml data available as object attributes
class YamlConfig < OpenStruct
  def initialize(path)
    yaml = YAML.load_file path

    super(yaml)
  end
end
