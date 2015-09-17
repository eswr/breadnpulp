class Pack < ActiveRecord::Base
  belongs_to :menu
  belongs_to :delivery
end
