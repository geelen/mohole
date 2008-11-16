class Script < ActiveRecord::Base
  belongs_to :user, :foreign_key => "creator_id"

  public_resource_for :index, :read
  creator_resource_for :write

  def createable_by? account
    !account.nil?
  end
end
