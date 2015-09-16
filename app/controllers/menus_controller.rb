class MenusController < ApplicationController

	before_action :logged_in_user
	before_action :admin_user

  def new
  	@menu = Menu.new
  end

  def create
  	@menu = Menu.new(menu_params)
  	if @menu.save
		flash[:success] = "Menu created!"
		redirect_to @menu
	else
		flash.now[:danger] = "Menu not created, please try again"
		render 'new'
	end
  end

  def show
  	@menu = Menu.find(params[:id])
  end

  def edit
  	@menu = Menu.find(params[:id])
  end

  def index
    @all_dates = Menu.select(:available_on).map(&:available_on).uniq
  	menu_on(@date) = Menu.where(available_on: date)
  end

  def update
  	@menu = Menu.find(params[:id])
  	if @menu.update_attributes(menu_params)
  		flash[:success] = "Menu updated"
  		redirect_to @menu
  	else
  		flash.now[:danger] = "Menu not updated, please try again"
  	end
  end

  def destroy
  	@menu = Menu.find(params[:id])
  	flash[:success] = "Menu deleted!"
  	@menu.destroy
  	redirect_to menus_path
  end

  private

  def menu_params
  	params.require(:menu).permit(:available_on, :kickerr_id, :price)  	
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

# Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_path
    end
  end

end
