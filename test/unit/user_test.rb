require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "A user" do    
    should_have_many :scripts
  end
end
