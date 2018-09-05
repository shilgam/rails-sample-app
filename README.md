# A toy app

A toy demo app to show off some of the power of Rails.
The purpose is to get a high-level overview of Ruby on Rails programming (and web development in general) by rapidly generating an application using scaffold generators, which create a large amount of functionality automatically.

As with the forthcoming sample application, the toy app will consist of users and their associated microposts (thus constituting a minimalist Twitter-style app).
The functionality will be utterly under-developed, and many of the steps will seem like magic, but worry not: the full sample app will develop a similar application from the ground up starting in Chapter 3, and I will provide plentiful forward-references to later material.
In the mean time, have patience and a little faith—the whole point of this tutorial is to take you beyond this superficial, scaffold-driven approach to achieve a deeper understanding of Rails.

## Boot the app

1. Run local webserver:

        $ rails server

1. View the welcome page: http://0.0.0.0:3000

### Deploy

1. \* [Create](https://signup.heroku.com/) and configure a new Heroku account

1. \* Check to see if your system already has the [Heroku command-line client](https://devcenter.heroku.com/articles/heroku-cli) installed:

        $ heroku --version

1. \* Log in and add your SSH key:

        $ heroku login
        $ heroku keys:add

1. Bundle without production gems (to prevent the local installation of any production gems)

        $ bundle install --without production

1. to create a place on the Heroku servers for the sample app to live:

        $ heroku create

1. to deploy the application:

        $ git push heroku master

NOTE:
- `*` - ignore step if it was done before
