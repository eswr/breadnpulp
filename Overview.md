Feature list:{
	User can edit deliveries only if the delivery status is confirmed.
	
}

Operator
	View
		List of despatches
			Despatch
				Time
				Status
				Rider
					Name
					Number
					Status
				List of orders
					Order
						Customer
							Name
							Number
						Postal address
						List of packs
							Pack
								Kickerr Name
								Quantity
		List of riders
			Rider
				Name
				Number
				Status
					Current status
					Update status link

		List of kickerrs

	Extra requirements
		Separate access level for operator

Despatch
	Logic
		expected_time_round_trip = {
			google_time_to_round_trip
			+ no_of_drops * average_time_at_drop
		}
	Views
		New
			List of riders
				Rider
					Name
					Number
					Status
						Name
						Till when?
			Expected time of completion
				Input
					Google time for round trip
					No of drops
					Average time at drop
			Extra
				Javascript for calculation
				Algorithm for best order clubbing - Bulky?

Invoice
	Backlogs
		Pack rates for some orders/customers
		Payment status of some orders/customer
		Missed orders
			3 days ago
			Sheet leak
	System
		Coupon code and discounts
		Invoice update on system

Despatch SMS
	Activate button
	Messages
		Rider
			List of orders
				Order
					Customer
						Name
						Number
					List of packs
						Pack
							Kickerr Name
							Quantity
					Postal Address
					Payment
						Amount
						Mode
		Customer
			"Your order has been despatched.."
			List of packs
				Pack
					Kickerr Name
					Quantity
			Payment
				Amount
				Mode
				Date

Order of imps
	1. Multiple user access level
	2. Delayed job
	3. Modelling - FoodRider
	4. Modelling - Operator
	5. 

Roles:
	1. Admin
	2. Operator
		1. Todays' despatches
		2. Chef view
	3. Rider
	
Food Items
	add column cost price

Kickerr
	calculate kickerr price from food items

Drops
	has many orders
	belongs to a despatch
	belongs to address
	expected drop time
	actual drop time
	

Despatch
	has many drops

