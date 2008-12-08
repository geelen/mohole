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
      assert_equal ["missing 'rewrites' base element!"], either.right
    end

    should "validate a yaml" do
      either = @script_validator.validate("---\nrewrites: []")
      assert either.isLeft
      expectedResult = {'rewrites' => []}
      assert_equal expectedResult, either.left
    end
  end
end

