[![Build Status](https://travis-ci.org/cyrusinnovation/CodeTestBotServer.svg?branch=travis)](https://travis-ci.org/cyrusinnovation/CodeTestBotServer)
[![Code Climate](https://codeclimate.com/github/cyrusinnovation/CodeTestBotServer.png)](https://codeclimate.com/github/cyrusinnovation/CodeTestBotServer)
[![Coverage Status](https://coveralls.io/repos/cyrusinnovation/CodeTestBotServer/badge.png)](https://coveralls.io/repos/cyrusinnovation/CodeTestBotServer)

# Code Test Bot Server

The API server for the Code Test Bot application.

### Installing
##### System Dependencies
- Ruby 2.1.1
- PostgreSQL

##### Bundler
User Bundler to install Gem dependencies.
```sh
bundle install
```

##### Database

You'll need to create a `codetestbot` role for Postgres (-d gives permission to create databases).
```sh
createuser -d codetestbot
```

Note that before you can run the `createuser` script, you'll need to have created at least one Postgres database using `createdb`.

Then you can run Rake to create and seed the database.
```sh
bundle exec rake db:create db:migrate db:seed RAILS_ENV=development
bundle exec rake db:create db:migrate RAILS_ENV=test
```

Note that `db:seed` is not called for the test environment, since rspec calls it prior to running each test.

##### Running Tests
Once the test DB is setup, you should be able to run the tests with RSpec.
```sh
bundle exec rspec
```
