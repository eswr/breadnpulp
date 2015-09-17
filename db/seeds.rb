# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

DeliveryStatus.delete_all
DeliveryStatus.create! id: 1, name: "In Progress"
DeliveryStatus.create! id: 2, name: "Placed"
DeliveryStatus.create! id: 3, name: "Shipped"
DeliveryStatus.create! id: 4, name: "Cancelled"