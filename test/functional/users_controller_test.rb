require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "A user" do
    setup do
      @user = User.find :first
    end

    # should_be_restful do |resource|
    #   resource.formats = [:html]
    #   resource.create.params = { :name => 'some name', :data => "my code" }
    #   resource.update.params = { :data => "different code" }
    # end
  end
end
