class ApplicationController < ActionController::Base
  include Hammock
  helper :all
  layout 'application'
  protect_from_forgery

  before_filter :login_from_session
  def login_from_session
    @current_account = User.find_by_id(session[:user_id])
  end
end
