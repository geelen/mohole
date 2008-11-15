require File.dirname(__FILE__) + '/../test_helper'
require 'uri'

class ScriptExecutorTest < Test::Unit::TestCase
  context "A script executor" do
    setup do
      @script_executor = ScriptExecutor.new
    end
    
    should "at least exist" do
      assert_not_nil @script_executor
    end
    
    should "should fetch a url" do
      uri = 'http://www.google.com'
      fetched = @script_executor.fetch_uri(uri)
      assert_equal Hpricot(open(uri)).to_s, fetched.to_s
    end
  end
end