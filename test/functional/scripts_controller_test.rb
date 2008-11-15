require File.dirname(__FILE__) + '/../test_helper'

class ScriptsControllerTest < ActionController::TestCase
  context "A script" do
    setup do
      @script = Script.find :first
    end

    # should_be_restful do |resource|
    #   resource.formats = [:html]
    #   resource.create.params = { :name => 'some name', :data => "my code" }
    #   resource.update.params = { :data => "different code" }
    # end
    
    should "have a base_uri" do
      assert_not_nil @script.base_uri
    end

    should "have a creator_id" do
      assert_not_nil @script.creator_id
    end
  end
end
