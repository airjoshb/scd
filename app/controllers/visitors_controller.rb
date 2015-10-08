class VisitorsController < ApplicationController
  def index
    @post = Article.active
  end

  def preview
    respond_to do |format|
      format.html { render layout: 'preview' }
    end
  end

  def atom
    @posts = Article.active

    respond_to do |format|
      format.atom {
        render :layout => false
        headers["Content-Type"] = 'application/rss+xml; charset=utf-8'
      }
    end
  end

  def sitemap
    respond_to do |format|
      format.xml {
        render :layout => false
        headers["Content-Type"] = 'text/xml'
      }
    end
  end

end
