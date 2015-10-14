class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper
  respond_to :json

  def create
    super
  end

  def new
    @articles = Article.status(1).active.popular.limit(12)

    super
  end

  def edit
    super
  end


  def add_tag
    authorize current_user
    current_user.tag_list.add(params[:tag])
    current_user.save
    render :nothing => true

  end

  def remove_tag
    authorize current_user
    current_user.tag_list.remove(params[:tag])
    current_user.save
    render :nothing => true

  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    @user = User.find(params[:id])
    @user_tags = @user.tag_list
    @interests=Article.tag_counts.order('count DESC').map { |tagging| { 'id' => tagging.id.to_s, 'name' => tagging.name, 'count' => tagging.count } }.uniq
    authorize @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(account_update_params)
        redirect_to articles_path
        sign_in(@user, :bypass => true)
      else
        @show_errors = true
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

  #def sign_up(resource_name, resource)
  #  false
  #end

  def sign_up_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :stripe_token, :tag_list)
  end

  def account_update_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :current_password, :stripe_token, :tag_list, :frequency)
  end
end
