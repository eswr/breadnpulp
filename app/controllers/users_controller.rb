class UsersController < ApplicationController

  before_action :logged_in_user,        only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,          only: [:show, :edit, :update]
  before_action :admin_user,            only: [:index, :destroy]
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @addresses = @user.addresses.all
    @address = @user.addresses.build if logged_in?
    @deliveries = @user.deliveries.order(delivery_date: :desc).order(at: :asc)
    @food_alert = @user.food_alert
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      flash.now[:danger] = "Profile not updated. Please try again."
      render 'edit'
    end
  end

  def index
    @users = User.order(created_at: :asc)
  end

  def destroy
    User.find(params[:id]).activated = false
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone_number, :source)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end

    # Confirms the correct user.
    def correct_user
      return true if current_user.admin?
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
