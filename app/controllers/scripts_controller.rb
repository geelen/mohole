class ScriptsController < ApplicationController

  nestable_by :user_id => :creator_id

end
