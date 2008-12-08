require File.dirname(__FILE__) + '/../test_helper'
require 'uri'
require 'yaml'

class ScriptValidatorTest < Test::Unit::TestCase
  context "A script validator" do
    setup do
      @script_validator = ScriptValidator.new
    end

    should "at least exist" do
      assert_not_nil @script_validator
    end

    should "not validate an empty yaml" do
      either = @script_validator.validate("---")
      assert either.isRight
      assert_equal ["[/] '---': not a mapping."], either.right
    end

    should "not validate a sequence" do
      either = @script_validator.validate("---\n- one\n- two\n- three")
      assert either.isRight
      assert_equal ["[/] not a mapping."], either.right
    end

    should "not validate some other map" do
      either = @script_validator.validate("---\none:\n  - two\n  - three")
      assert either.isRight
      assert_equal ["[/one] key 'one:' is undefined."], either.right
    end

    should "validate the simplest yaml" do
      either = @script_validator.validate("---\nrewrites: []")
      assert either.isLeft
      expectedResult = {'rewrites' => []}
      assert_equal expectedResult, either.left
    end

    should "validate a yaml with some removes" do
      either = @script_validator.validate(<<EOYAML)
---
rewrites:
  - remove:
    - head
    - body
EOYAML
      assert either.isLeft
      expectedResult = {"rewrites"=>[{"remove"=>["head", "body"]}]}
      assert_equal expectedResult, either.left
    end

    should "not validate a yaml with some bad removals" do
      either = @script_validator.validate(<<EOYAML)
---
rewrites:
  - remove:
    - head
    - 5
EOYAML
      assert either.isRight
      assert_equal ["[/rewrites/0/remove/1] '5': not a string."], either.right
    end

    should "validate a yaml with some injects" do
      either = @script_validator.validate(<<EOYAML)
---
rewrites:
  - prepend:
    - at: body
      insert: "some_string"
EOYAML
      assert either.isLeft
      expectedResult = {"rewrites"=>[{"prepend"=>[{"at" => "body", "insert" => "some_string"}]}]}
      assert_equal expectedResult, either.left
    end

    should "validate a yaml with some injects" do
      either = @script_validator.validate(<<EOYAML)
---
rewrites:
  - prepend:
    - at: body
EOYAML
      assert either.isRight
      assert_equal ["[/rewrites/0/prepend/0] key 'insert:' is required."], either.right
    end

    should "validate a yaml with some injects" do
      either = @script_validator.validate(<<EOYAML)
---
rewrites:
  - prepend:
    - insert: "some_text"
EOYAML
      assert either.isRight
      assert_equal ["[/rewrites/0/prepend/0] key 'at:' is required."], either.right
    end
  end
end

