## Deploy with Heroku

We moved the `sqlite3` gem into both `development` and `test` groups. Furthermore, we created a new `production` group and added the postgres gem `pg`.

To locally install gems without production run: `bundle install --without production`

Heroku rails deploy guide: https://devcenter.heroku.com/articles/getting-started-with-rails6