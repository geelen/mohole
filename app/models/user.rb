class User < ActiveRecord::Base
  has_many :scripts, :foreign_key => "creator_id"

  public_resource_for :read, :index
  partitioned_resource_for :write

  def createable_by? account
    true # Anyone can sign up
  end
end
