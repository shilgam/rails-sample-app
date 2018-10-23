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

1. Configure Amazon S3 cloud to store images (Note: S3 is a paid service, but the storage needed to set up this app costs less than a cent per month)

    1. Sign up for an [Amazon Web Services](http://aws.amazon.com/) account

    1. Create a user via [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/) and record the access key and secret key.

    1. Create an S3 bucket (with a name of your choice) using the [AWS Console](https://console.aws.amazon.com/s3), and then grant read and write permission to the user created in the previous step.

    1. Define Heroku ENV variables:

            $ heroku config:set S3_ACCESS_KEY=<access key>
            $ heroku config:set S3_SECRET_KEY=<secret key>
            $ heroku config:set S3_BUCKET=<bucket name>
            $ heroku config:set S3_REGION=<bucket region>
NOTE:
- `*` - ignore step if it was done before
