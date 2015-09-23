class ShareEmailsController < ApplicationController
  def new
    @share = ShareEmail.new
  end

  def create
    @share = ShareEmail.new(share_emails_params)
    @share.request = request
    if @share.deliver
      render :nothing => true
    else
      flash.now[:error] = 'Cannot send message.'
      render :nothing => true
    end

  end

  def share_emails_params
    params.require(:share_email).permit(:name, :email, :message, :title, :file, :recipient, :nickname, :url)
  end
end