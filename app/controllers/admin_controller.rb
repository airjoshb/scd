class AdminController < ApplicationController
  before_filter :authenticate_user!


  def dashboard
    @articles = Article.all
    @users = User.all
    @deleted = Article.status(4)
    respond_to do |format|
      format.js
      format.html
    end
  end

end
