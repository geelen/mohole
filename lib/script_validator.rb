require File.join(File.dirname(__FILE__), 'either')
require 'yaml'
require 'kwalify'

class ScriptValidator
  SCHEMA = <<-SCHEMA
---
type: map
mapping:
  "rewrites":
    type: seq
    sequence:
      - type: map
        mapping:
          "remove":
            type: seq
            sequence:
              - type: str
          "prepend":
            type: seq
            sequence:
              - type: map
                mapping:
                  "at":
                    type: str
                    required: yes
                  "insert":
                    type: str
                    required: yes
  SCHEMA

  def validate(text)
    parsed = YAML.load(text)
    schema = YAML.load(SCHEMA)
    validator = Kwalify::Validator.new(schema)
    errors = validator.validate(parsed)
    Either.leftIf(errors.empty?, parsed, errors.map { |e| "[#{e.path}] #{e.message}" })
  end
end