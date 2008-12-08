require File.join(File.dirname(__FILE__), 'either')
require 'yaml'

class ScriptValidator
  def validate(text)
    parsed = YAML.load(text)
    p parsed
    Either.leftIf(parsed.is_a?(Hash), parsed, ["missing 'rewrites' base element!"])
  end
end