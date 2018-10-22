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

1. Install [ImageMagick](https://imagemagick.org) on your local machine for image resizing:

        $ brew install imagemagick

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

1. Populate the production db with sample users (using the `pg:reset` task to reset the production db):

        $ heroku pg:reset DATABASE
        $ heroku run rails db:migrate
        $ heroku run rails db:seed
        $ heroku restart

1. Configure app to send email in production

    1. Add SendGrid add-on to the app (This requires adding credit card info to Heroku account, but there is no charge when verifying. The "starter" plan limited to 400 emails a day but costs nothing):

            $ heroku addons:create sendgrid:starter

NOTE:
- `*` - ignore step if it was done before
