## Deploy with Heroku

We moved the `sqlite3` gem into both `development` and `test` groups. Furthermore, we created a new `production` group and added the postgres gem `pg`.

Heroku rails deploy guide: https://devcenter.heroku.com/articles/getting-started-with-rails6

## Run locally

1. `yarn install`
2. `bundle install`
3. `rails s`

To locally install gems without production run: `bundle install --without production`

## Articles setup

1. Create migration: `rails generate migration create_articles`
2. Add desired attributes to the created migration
3. Run migration: `rails db:migrate`

Rails will only run migrations, which weren't already executed.

This means that you can't edit already executed migration files and then run the migration again.

If the migration only happened locally so far, you can rollback the last migration with `rails db:rollback`.
Otherwise, you should always make a new migration!

### Adding new fields to an already existing table

1. Create migration e.g: `rails generate migration add_timestamps_to_articles`
2. Make the desired adjustments to the created migration e.g:

```ruby
# 20211006104245_add_timestamps_to_articles.rb
class AddTimestampsToArticles < ActiveRecord::Migration[6.1]
  def change
    # Method   :Table,    :attribute,  :type
    add_column :articles, :created_at, :datetime
    add_column :articles, :updated_at, :datetime
  end
end
```

3. `rails db:migrate`

