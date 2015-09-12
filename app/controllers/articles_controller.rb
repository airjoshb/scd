class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :recommend, :unrecommend]
  add_breadcrumb 'lineup', 'articles_path'

  # GET /articles
  # GET /articles.json
  def index
    if params[:tag].present?
       @tag = ActsAsTaggableOn::Tag.find_by_name(params[:tag])
       @articles = Article.active.tagged_with(@tag).popular
       set_breadcrumb_tag_for @tag
    elsif current_user.present?
       @user = current_user
       @tags = @user.tags
       @articles = Article.tagged_with(@tags, :any => :true).active.popular
    else
      @articles = Article.active
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @related_articles = @article.find_related_tags.active.limit(5)
    set_breadcrumb_for @article
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # article /articles
  # article /articles.json
  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id

    @article.save
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :subhead, :body, :slug, :origin, :image, :publish_date, :user_id, :tag_list)
    end

    def set_breadcrumb_tag_for tag
      add_breadcrumb tag, "articles_path(:tag => #{tag.id})"
    end

    def set_breadcrumb_for cat
      add_breadcrumb cat.title, "article_path(#{cat.id})"
    end
end