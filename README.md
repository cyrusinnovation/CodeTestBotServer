![Build Status](https://travis-ci.org/cyrusinnovation/CodeTestBotServer.svg?branch=travis)
![Code Climate](https://codeclimate.com/github/cyrusinnovation/CodeTestBotServer.png)
![Coverage Status](https://coveralls.io/repos/cyrusinnovation/CodeTestBotServer/badge.png)

# Code Test Bot Server

The API server for the Code Test Bot application.

### Installing
##### System Dependencies
- Ruby 2.1.1
- PostgreSQL

##### Bundler
User Bundler to install Gem dependencies.
```
bundle install
```

##### Database
You'll need to create a `codetestbot` role for Postgres.
```
createuser codetestbot
```

Then you can run Rake to create and seed the database.
```
bundle exec rake db:create db:seed RAILS_ENV=test
bundle exec rake db:create db:seed RAILS_ENV=development
```

##### Running Tests
Once the test DB is setup, you should be able to run the tests with RSpec.
```
bundle exec rspec
```
