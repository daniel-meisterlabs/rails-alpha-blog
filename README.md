## Deploy with Heroku

We moved the `sqlite3` gem into both `development` and `test` groups. Furthermore, we created a new `production` group and added the postgres gem `pg`.

Heroku rails deploy guide: https://devcenter.heroku.com/articles/getting-started-with-rails6

## Run locally

1. `yarn install`
2. `bundle install`
3. `rails s`

To locally install gems without production run: `bundle install --without production`

## Articles setup

### Create table

1. Create migration: `rails generate migration create_articles`
2. Add desired attributes to the created migration
3. Run migration: `rails db:migrate`

Rails will only run migrations, which weren't already executed.

This means that you can't edit already executed migration files and then run the migration again.

If the migration only happened locally so far, you can rollback the last migration with `rails db:rollback`.
Otherwise, you should always make a new migration!

### Create model

1. Create new model `article.rb` (singular!) in `app/models` directory
2. Test that your connection to the table is working with help of the rails console:

```bash
# Open interactive rails console
rails console

# Will error if connection failed.
# Otherwise, yields the table contents
Article.all
```

3. Add attribute validation

This is important to e.g: Disallow creating articles with empty titles or descriptions

```ruby
# app/models/article.rb
class Article < ApplicationRecord
  #         :attribute, validations
  validates :title, presence: true, length: { minimum: 6, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 300 }
end
```

4. Add at least 1 article to the database (we need it later):

```bash
article = Article.new(title: "First Article", description: "First article description")
article.save
```

### Handling routes

We only expose the `show` route at first and will gradually add routes as we need them.

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to: 'pages#about'
  resources :articles, only: [:show]
end
```

You can check for all available routes in a readable way with: `rails routes --expanded`.

If you start the server now and go to `localhost:3000/articles/1`, you will get an error saying that the `ArticlesController` was not found. However, this confirms that the route works.

### Creating `ArticlesController#show` action and corresponding views

To fix the error from last section, we simply create the `ArticlesController`:

```ruby
# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  def show
  end
end
```

If you now refresh the `localhost:3000/articles/1` page, an error will tell you, that `ArticlesController#show` is missing a template. So let's create the template:

```ruby
# app/views/articles/show.html.erb
<h1>Showing article details</h1>
```

Visiting `articles/1` again confirms that the route is working as intended now.

### Display article data

Right now we don't actually display article data when accessing the article show route `localhost:3000/articles/1`.

To do that, we first need to make the article data available in the `ArticlesController`:

```ruby
# app/controllers/articles_controller.rb #show method
def show
  # Instance variables are prefixed with @ and make
  # the variable avialable in the corresponding action.
  # `params[:id]` returns the id from the url.
  @article = Article.find(params[:id])
end
```

Now we can display the data in the view:

```ruby
# app/views/articles/show.html.erb
<p>
  <strong>Title: </strong>
  <%= @article.title %>
</p>
<p>
  <strong>Description: </strong>
  <%= @article.description %>
</p>
```
Note that that `<% ... %>` only evaluates ruby. To also display it, you need `<%= ... %>`

## Examples

### Adding new fields to an already existing table

1. Create migration e.g: `rails generate migration add_timestamps_to_articles`
2. Make the desired adjustments to the created migration e.g:

```ruby
# db/migrate/20211006104245_add_timestamps_to_articles.rb
class AddTimestampsToArticles < ActiveRecord::Migration[6.1]
  def change
    # Method   :Table,    :attribute,  :type
    add_column :articles, :created_at, :datetime
    add_column :articles, :updated_at, :datetime
  end
end
```

3. `rails db:migrate`

### Rails console tips

Start rails console: `rails c`

#### Manipulate database directly

```bash
Article.create(title: "First Article", description: "Created via rails console")
```

#### Using variables

The data will not hit the database directly, so you can double check your changes, before saving them. Any helper variables you create will be deleted after exiting the rails console.

```bash
# Creates the `article` object with the `Article` class
article = Article.new

# Getters
article
article.title
article.description


# Setters
article.title = "Second Article"
article.description = "Created with Setters"

# Save to database
article.save
```

You can also supply data directly, when creating the helper object:

```bash
article = Article.new(title: "Third Article", description: "article = Article.new(...)")

article.save
```

Deletions will hit the database directly!

```bash
article.destroy
```

#### Viewing error messages

```bash
# Attribute validation should prevent saving an article with empty fields
article = Article.new
article.save
# => false

# Get the readable errors that occurred
article.errors.full_messages
# => ["Title can't be blank", "Description can't be blank"]
```

### Debugging with `byebug`

You can set `byebug` anywhere in the code, which will pause the application at exactly that point, before continuing.

This allows you to inspect variable values in the console, which are available at the `byebug` pausing.

Example:

```ruby
# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  def show
    @article = Article.find(params[:id])
    byebug # Pauses the application exactly here
  end
end
```

Start the server and visit any article, e.g: `localhost:3000/articles/1`.

When the application is paused, a `byebug` console is opened in the same terminal window, where you started the rails server. Here you can then inspect all variables, which are currently available.

```bash
params
# => <ActionController::Parameters {"controller"=>"articles",
# "action"=>"show", "id"=>"1"} permitted: false>

params[:id]
# => "1"

@article.title
# => "First Article"

# To continue the application
continue
```


## Useful rails commands

1. Readable list all available routes: `rails routes --expanded`


