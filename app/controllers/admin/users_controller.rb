class Admin::UsersController < Devise::RegistrationsController
  before_filter :authenticate_user!
  respond_to :json

  def create
    super
  end

  def new
    super
  end

  def edit
    super
  end

  def add_role
    respond_to do |format|
      format.js do
        role = params[:role]
        @user = User.find(params[:id])
        @user.role = role
        @user.save
        # manage return status here
        head :ok
      end
    end
  end

  private
  def build_resource(*args)
    super

    if params[:plan]
      resource.add_role(params[:plan])
    end
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  def sign_up(resource_name, resource)
    false
  end

  def sign_up_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :stripe_token, :tag_list)
  end

  def account_update_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :current_password, :stripe_token, :tag_list)
  end

end