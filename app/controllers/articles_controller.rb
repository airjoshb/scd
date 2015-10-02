class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :recommend, :unrecommend, :change_status]

  # GET /articles
  # GET /articles.json
  def index
    if params[:tag].present?
       @tag = ActsAsTaggableOn::Tag.find_by_name(params[:tag])
       @articles = Article.status(1).active.tagged_with(@tag).popular
       @user = current_user
       @tags = @user.tags
    elsif current_user.present?
       @user = current_user
       @tags = @user.tags
       @articles = Article.tagged_with(@tags, :any => :true).status(1).active.popular
    else
      @articles = Article.active
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @related_articles = @article.find_related_tags.active.limit(5)
    @share = ShareEmail.new({ title: @article.title, file: @article.image.medium, url: url_for(@article) })
  end

  def tagged
    if params[:tag].present?
      @articles = Article.tagged_with(params[:tag])
    else
      @articles = Article.all
    end
  end

  def recommend
    @user = current_user
    @user.recommend(@article)
    if request.xhr?
      render json: { count: @article.recommended_users.count, id: params[:id] }
    else
      redirect_to @article
    end
  end

  def unrecommend
    @user = current_user
    @user.unrecommend(@article)
    if request.xhr?
      render json: { count: @article.recommended_users.count, id: params[:id] }
    else
      redirect_to @article
    end
  end

  def change_status
    @articles = Article.all
    @article.statuses.build(status: params[:status])
    if params[:status] = "published"
      @article.publish_date = Time.current
    end
    @article.save
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :subhead, :body, :slug, :origin, :image, :publish_date, :user_id, :tag_list, statuses_attributes: [:status, :article_id], locations_attributes: [:line_1, :line_2, :city, :state_or_province, :postal_code] )
    end

end