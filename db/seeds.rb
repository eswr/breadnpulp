# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

DeliveryStatus.delete_all
DeliveryStatus.create! id: 1, name: "Tentative"
DeliveryStatus.create! id: 2, name: "Confirmed"
DeliveryStatus.create! id: 3, name: "Processing"
DeliveryStatus.create! id: 4, name: "Despatched"
DeliveryStatus.create! id: 5, name: "Delivered"
DeliveryStatus.create! id: 6, name: "Payment Complete"
DeliveryStatus.create! id: 7, name: "Returned"
DeliveryStatus.create! id: 8, name: "Cancelled"
DeliveryStatus.create! id: 9, name: "Deactivated"