class MenusController < ApplicationController

	before_action :logged_in_user
	before_action :admin_user

  def new
  	@menu = Menu.new
    @kickerrs_array = Kickerr.all.map { |kickerr| [kickerr.name + kickerr.created_at.strftime("created at: %a %e %b %Y %I:%M%p"), kickerr.id] }
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
    @menus = Menu.paginate(:page => params[:page]).order(available_on: :desc)
    respond_to do |format|
      format.html
      format.csv { render text: Menu.all.to_csv }
    end
  end

  def update
  	@menu = Menu.find(params[:id])
  	if @menu.update_attributes(menu_params)
  		flash[:success] = "Menu updated"
  		redirect_to menus_path
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
