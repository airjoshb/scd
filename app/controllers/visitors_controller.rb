class VisitorsController < ApplicationController
  def index
    @post = Article.active
  end

  def preview
    respond_to do |format|
      format.html { render layout: 'preview' }
    end
  end
end
