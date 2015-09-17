class Delivery < ActiveRecord::Base
  belongs_to :user
  belongs_to :address

  has_many :packs
  has_many :menus, through: :packs
end
