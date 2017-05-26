# Wikipedia Daily Events

## Objective
This app (pseudo) summarizes events on a given day scraped from Wikipedia, built with high-volume in mind.

## Demonstration Topics
### Backend
* Ruby on Rails
* RESTful APIs
* HTTP caching
* Action caching
* Custom model and api validators
* Custom errors and error handling
* HTML scraping

### Frontend
* Angular 1.5.x
* Single Page App
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
6. Make sure node is v0.12.0
7. `npm install`
8. `bower install`
9. `gulp build`

## Starting the App
The app consists of a Rails backend and an Angular SPA running on different ports.
1. From root project directory, `rails s`
2. From client directory, `gulp serve`

OR from client directory, `gulp serve:full-stack`

## Running Tests
* `rspec`
AND
* `cd client`
* `gulp test`

## TODOs
There's always more to be done to improve optimization
* Model caching
* Background jobs
* Angular $cacheFactory
* Lazy loading
* Lazy JSON generator + streaming
* Protractor specs
* Angular 2.0 upgrade
* Angular Universal server side rendering
* Webpack 2 tree shaking