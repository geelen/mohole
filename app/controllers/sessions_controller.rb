class SessionsController < ApplicationController
  
  def new
    # lol
    @user = User.new
  end

  def create
    if @current_account = User.find_by_name((params[:user] || {})[:name])
      reset_session
      session[:user_id] = @current_account.id
      redirect_to root_path
    end
  end
  
  def destroy
    reset_session
    redirect_to root_path
  end
  
end
