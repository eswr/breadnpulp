class KickerrsController < ApplicationController

	before_action :logged_in_user
	before_action :admin_user

  def new
  	@kickerr = Kickerr.new
  end

  def create
  	@kickerr = Kickerr.new(kickerr_params)
  	if @kickerr.save
		flash[:success] = "#{@kickerr.name} created!"
		redirect_to @kickerr
	else
		flash.now[:danger] = "#{@kickerr.name} not created, please try again"
		render 'new'
	end
  end

  def edit
  	@kickerr = Kickerr.find(params[:id])
  end

  def show
  	@kickerr = Kickerr.find(params[:id])
  end

  def index
  	@kickerrs = Kickerr.paginate(page: params[:page])
  end

  def update
	@kickerr = Kickerr.find(params[:id])
	if @kickerr.update_attributes(kickerr_params)
		flash[:success] = "#{@kickerr.name} updated"
		redirect_to @kickerr
	else
		flash.now[:danger] = "#{@kickerr.name} not updated, please try again"
	end
  end

  def destroy
	@kickerr = Kickerr.find(params[:id])
	flash[:success] = "#{@kickerr.name} deleted!"
	@kickerr.destroy
	redirect_to kickerrs_path
  end

  private

  	def kickerr_params
  		params.require(:kickerr).permit(:name, :price, :description, { food_item_ids: [] })
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
