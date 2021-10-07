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

  def new
    @article = Article.new
  end

  def create
    # https://api.rubyonrails.org/v6.1.4/classes/ActionController/StrongParameters.html
    # You need to permit the submitted fields for the articles table!
    @article = Article.new(params.require(:article).permit(:title, :description))

    if @article.save
      flash[:notice] = "Article was created successfully."
      redirect_to article_path(@article) # shortcut: redirect_to @article
    else
      render 'new'
    end
  end
end
