class ArticlesController < ApplicationController
  def show
    # Instance variables are prefixed with @ and make
    # the variable avialable in the corresponding view.
    # `params[:id]` returns the id from the url.
    @article = Article.find(params[:id])
  end

  def index
    @articles = Article.all
  end
end
