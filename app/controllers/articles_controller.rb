class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :validate_owner, only: [:edit, :update, :destroy]

  # this action will be used as index for all articles and also to show search results
  def index
    @articles = Article.search(params[:search])
  end

  def new
    @article = Article.new
  end

  def create
    # get all the tags by given tag_ids from form and also load the subtags linked to it
    tags = Tag.where( id: params[:article][:tag_ids] ).includes(:sub_tags) if params[:article][:tag_ids].present?

    # Convert subtag_ids to integer array, because we need to compare it with integer to load subtags under tags
    # Note: Here I am only subtags which are present under the tags, and here I need to select because
    # frontend functionality for filtering subtags according to tag is not complete
    sub_tag_ids = params[:article][:sub_tag_ids].map(&:to_i) rescue []
    sub_tags = tags.flat_map{ |tag| tag.sub_tags.select { |sub_tag| sub_tag_ids.include?(sub_tag.id) } } if tags.present? && sub_tag_ids.present?

    Article.transaction do
      @article = Article.new( article_params.merge!( owner_id: current_user.id ) )
      @article.save!

      @article.tags << tags if tags.present?
      @article.sub_tags << sub_tags if sub_tags.present?
    end

    redirect_to root_path, notice: 'Article was successfully created.'
  rescue Exception => ex
    render :new
  end

  def show
    @tags_and_subtags_hash = @article.get_tags_and_subtags_hash
  end

  def edit
  end

  def update
    @article.update_with_tags(article_params, params[:article][:tag_ids], params[:article][:sub_tag_ids])

    redirect_to root_path, notice: 'Article was successfully updated.'
  rescue Exception => ex
    render :edit
  end

  def destroy
    @article.destroy

    redirect_to articles_path, notice: 'Article was successfully destroyed.'
  end

  private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:name, :description)
    end

    # this is needed for actions like, edit, update, destroy because only owners should have access to do these
    def validate_owner
      unless @article.owner == current_user
        redirect_to root_path, notice: 'You do not have edit access to the article!'
      end
    end
end