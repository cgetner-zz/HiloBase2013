class AdminAccessLevel < ActiveRecord::Base
  attr_accessible :administrator_id, :access_level_id
  belongs_to :administrator
  belongs_to :access_level
  # belongs_to :level, :polymorphic => true
end
