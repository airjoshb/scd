class Admin::ArticlesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_article, only: [:edit, :update, :destroy]

  # GET /articles/new
  def new
    @article = Article.new
    @article.locations.build
    @article.events.build
  end

  # GET /articles/1/edit
  def edit
  end

  # article /articles
  # article /articles.json
  def create
    @article = current_user.articles.build(article_params)
    respond_to do |format|
      if @article.save
        format.html { redirect_to admin_path, notice: 'Article was successfully created.' }
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
        format.html { redirect_to admin_path, notice: 'Article was successfully updated.' }
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
    render nothing: true
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :subhead, :body, :slug, :origin, :image, :publish_date, :user_id, :why, :tips, :tag_list, :tags, statuses_attributes: [:status, :article_id], locations_attributes: [], events_attributes: [] )
    end

end