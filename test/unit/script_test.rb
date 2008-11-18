require 'test_helper'

class ScriptTest < ActiveSupport::TestCase
  context "A script" do
    #todo: this fails because script belongs_to creator, not user
#    should_belong_to :user
  end
end
