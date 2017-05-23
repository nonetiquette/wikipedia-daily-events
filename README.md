# Wikipedia Daily Events

## Objective
This app (pseudo) summarizes events on a given day scraped from Wikipedia, built with high-volume in mind.

## Demonstration Topics
### Backend
* Ruby on Rails
* RESTful APIs
* HTTP caching
* Action caching
* Model caching (To be added)
* Background jobs (To be added)
* Custom model and api validators
* Custom errors and error handling
* HTML scraping

### Frontend
* Angular 1.5
* Single Page App
* Angular $cacheFactory (To be added)
* Bootstrap UI

## Installing
1. `brew install postgresql`
2. Make sure PostgreSQL is started (e.g. ` pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`)
2. Create DBs
`conn = PG.connect(dbname: 'postgres')`
`conn.exec("CREATE DATABASE wikipedia_daily_events_development")`
`conn.exec("CREATE DATABASE wikipedia_daily_events_test")`
`conn.exec("CREATE DATABASE wikipedia_daily_events")`
3. `bundle install`
4. `bundle exec rake db:migrate`
5. `cd client`
6. Make sure you are on npm v.0.12.0 or so?
7. `npm install`
8. `bower install`

## Starting the App
The app consists of a Rails backend and an Angular SPA running on different ports.
1. From root project directory, `rails s`
2. From client directory, `gulp serve`

OR from client directory, `gulp serve:full-stack`

## Running Tests
* `rspec test`
AND
* `cd client`
* `gulp protractor`
* `gulp karma`