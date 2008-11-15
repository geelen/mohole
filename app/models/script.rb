class Script < ActiveRecord::Base
  belongs_to :user, :foreign_key => "creator_id"
end
