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




