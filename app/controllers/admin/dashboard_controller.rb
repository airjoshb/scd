class Admin::DashboardController < ApplicationController
  before_filter :authenticate_user!


  def index
    @articles = Article.all
    @users = User.all
    @deleted = Article.status(4)
    @roles = User.roles
    respond_to do |format|
      format.js
      format.html
    end
  end



end
