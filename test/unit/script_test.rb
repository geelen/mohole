require 'test_helper'

class ScriptTest < ActiveSupport::TestCase
  context "A script" do
    should_belong_to :user
  end
end
