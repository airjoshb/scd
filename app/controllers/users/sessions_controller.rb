class Users::SessionsController < Devise::SessionsController
  include ApplicationHelper
  respond_to :json

  def create
    super
  end

  def new
    super
  end
end
