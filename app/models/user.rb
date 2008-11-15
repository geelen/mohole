class User < ActiveRecord::Base
  has_many :scripts, :foreign_key => "creator_id"
end
