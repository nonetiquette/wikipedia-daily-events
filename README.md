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
3. Create DBs
```conn = PG.connect(dbname: 'postgres')
conn.exec("CREATE DATABASE wikipedia_daily_events_development")
conn.exec("CREATE DATABASE wikipedia_daily_events_test")
conn.exec("CREATE DATABASE wikipedia_daily_events")```
4. `bundle install`
5. `bundle exec rake db:migrate`
6. `cd client`
7. Make sure node is v0.12.0
8. `npm install`
9. `bower install`
10. `gulp build`

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