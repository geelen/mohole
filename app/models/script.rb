class Script < ActiveRecord::Base

  public_resource_for :index, :read
  creator_resource_for :write

  def createable_by? account
    !account.nil?
  end

end
