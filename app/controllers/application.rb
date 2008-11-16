class ApplicationController < ActionController::Base
  include Hammock
  helper :all
  layout 'application'
  protect_from_forgery

  before_filter :mock_login
  def mock_login
    @current_account = User.find_by_name ENV["USER"]
  end
end
