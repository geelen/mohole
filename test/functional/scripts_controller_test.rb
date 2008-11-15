require File.dirname(__FILE__) + '/../test_helper'

class ScriptsControllerTest < ActionController::TestCase
  context "A script" do
    setup do
      @script = Script.find :first
    end
    
    should "have a base_uri" do
      assert_not_nil @script.base_uri
    end

    should "have a creator_id" do
      assert_not_nil @script.creator_id
    end
  end
end
