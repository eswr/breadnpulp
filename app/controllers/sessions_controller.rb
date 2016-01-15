class SessionsController < ApplicationController
  before_action :not_logged_in,     only: :new

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or root_path
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def create_omniauth
    user = User.from_omniauth(env["omniauth.auth"])
    log_in user
    redirect_to user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def not_logged_in
    redirect_to current_user if logged_in?
  end

end
