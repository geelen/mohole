class User < ActiveRecord::Base

  public_resource_for :read, :index
  partitioned_resource_for :write

  def createable_by? account
    true # Anyone can sign up
  end

end
