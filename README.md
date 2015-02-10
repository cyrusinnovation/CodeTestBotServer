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

Make sure Postgres is running, you can do this by simply opening the application after downloading it. You should see the elephant logo in your menu bar on OSX. It should be running on the default port: 5432.

Make sure you have created at least one Postgres database:
```sh
createdb
```

Create a `codetestbot` role for Postgres (-d gives permission to create databases):
```sh
createuser -d codetestbot
```

Then you can run Rake to create and seed the database.
```sh
bundle exec rake db:create db:migrate db:seed RAILS_ENV=development
bundle exec rake db:create db:migrate RAILS_ENV=test
```

Note that `db:seed` is not called for the test environment, since rspec calls it prior to running each test.

Before you can successfully use CodeTestBot in conjunction with the client application (CodeTestBotApp), you'll need to set the yaml file expected by Figaro to configure your local environment. Rename config/application.yml.example to config/application.yml. If necessary, add a line to use the development token. Your settings should look like below:

```
development:
  BASE_URI: http://localhost:3000
  USE_DEV_TOKEN: "true"
```

Lastly, before running CodeTestBotApp, run CodeTestBotServer:
```sh
rails server
```

##### Running Tests
Once the test DB is setup, you should be able to run the tests with RSpec.
```sh
bundle exec rspec
```
