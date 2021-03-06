class SubscriptionsController < ApplicationController
  def new
  	@subscription = Subscription.new(subscription_params)
  	@user = @subscription.user
  end

  def create
  	@subscription = Subscription.new(subscription_params)
  	if @subscription.save
  		flash[:sucess] = "Sucessfully subscribed"
  		redirect_to @subscription.user
  	else
  		flash.now[:danger] = "Please try again"
  		render 'new'
  	end
  end

  def show
  end

  def assign_packs_to_subscriptions
  	assign_packs
  	redirect_to root_path
  end

  private

  	def subscription_params
		params.require(:subscription).permit(:user_id, :start_date, :no_of_days, :at, :address_id, :delivery_status_id, :payment_status_id, :veg_qty, :egg_qty, :non_veg_qty)
	end

	def assign_packs
		# setting packs
		types = [:v, :e, :n]

		# hash of menu items available valued to key as veg_type
		availability = {}
		menus = Menu.where(available_on: Time.zone.tomorrow).eager_load(:kickerr)
		menus.each do |menu|
			availability[menu.kickerr.veg_type.first.downcase.to_sym] = menu.id
		end

		deliveries = Delivery.where(delivery_date: Time.zone.tomorrow).where.not(subscription_id: nil)
		deliveries.each do |delivery|
			if delivery.packs.nil?
				subscription = delivery.subscription
				requirement = { n: subscription.non_veg_qty,
								e: subscription.egg_qty,
								v: subscription.veg_qty }

				for i in 0..2
					if availability[types[i]].nil?
						requirement[types[i-1]] += requirement[types[i]]
						requirement[types[i]] = 0
					end
				end

				types.each do |type|
					if requirement[type] > 0
						delivery.packs.create(menu_id: availability[type], quantity: requirement[type])
					end
				end
			end
		end
	end
end
