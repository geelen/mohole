class User < ActiveRecord::Base
  has_many :scripts, :foreign_key => "creator_id"

  public_resource_for :read, :index, :create
  partitioned_resource_for :write

  attr_accessible_on_create :email, :name
  attr_accessible_on_update :name
end
