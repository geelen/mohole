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
      assert !@script_validator.validate("---")
    end
  end
end

