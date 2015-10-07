class Admin::UsersController < Devise::RegistrationsController
  before_filter :authenticate_user!
  respond_to :json

  def create
    super
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])

  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    render :nothing => true
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_without_password(user_params)
        format.html { redirect_to admin_path, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
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


  def sign_up(resource_name, resource)
    false
  end

  def sign_up_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :stripe_token, :tag_list)
  end

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :current_password, :stripe_token, :tag_list)
  end

end