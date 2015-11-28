class RolesController < ApplicationController

	before_action :admin_user

	def index
		@roles = Role.all.eager_load :users
		if params[:phone_number] && params[:role_name]
			@user = User.find_by(phone_number: params[:phone_number])
			if @user.add_role params[:role_name].downcase
				flash[:success] = "#{params[:role_name]} added to #{@user.name}"
				redirect_to roles_path
			else
				flash.now[:danger] = "Role not added. Please try again."
				render 'new'
			end
		end
	end

	private
		def admin_user
			redirect_to root_path unless current_user.admin?
		end
end
