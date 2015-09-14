class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :address
  belongs_to :order_status

  has_and_belongs_to_many :menus
end
