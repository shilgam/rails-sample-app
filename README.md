# Ruby on Rails Tutorial sample application

This is the sample application for
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](http://www.railstutorial.org/)
by [Michael Hartl](http://www.michaelhartl.com/).

## Usage

1. Clone the repo and install the needed gems:

        $ bundle install --without production

1. Migrate the database:

        $ rails db:migrate

1. Create test data:

        $ rails db:migrate:reset
        $ rails db:seed

1. Run the test suite:

        $ rails test

    1. Automatically & intelligently launch tests when you create or modify files:

            $ bundle exec guard

1. Run the app in a local server:

        $ rails server


## Deploy to Heroku

1. \* [Create](https://signup.heroku.com/) and configure a new Heroku account

1. \* Check to see if your system already has the [Heroku command-line client](https://devcenter.heroku.com/articles/heroku-cli) installed:

        $ heroku --version

1. \* Log in and add your SSH key:

        $ heroku login
        $ heroku keys:add

1. Create a place on the Heroku servers for the app:

        $ heroku create

1. Deploy the app:

        $ git push heroku master

1. Migrate the production db:

        $ heroku run rails db:migrate

NOTE:
- `*` - ignore step if it was done before
