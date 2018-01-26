# README

## Development

### Prerrequisites: 
* Ruby version: 2.2.2.

* System dependencies: before bundling, make sure you have xcode command line tools installed (`xcode-select install` will get you there)

* Configuration: in development you need to provide an environment variable called MAGE_RW_PASSWORD (export it in a terminal session or put it in some *rc file) with the password for your dev box's legacy database. If you want to test out mutations, also set the `MAGE_URI` environment variable to be able to talk directly to the legacy api.

* Database initialization: the default database.yml assumes you're tunneling back to your dev box's copy of the legacy database on port 3316; if you set up your tunnels in your ssh config (instead of running ad-hoc) you need to have a session open (ssh to your dev box on another terminal tab).

### Install dependencies

```
bundle install
```

### Check your db connection

An easy way to check that your db config is correct (which, after nokogiri's native deps, is the next big headache here), you can jump on a rails console and run a test query, should look like this:

```bash
λ ~/product_api master* bin/rails console
Running via Spring preloader in process 93742
Loading development environment (Rails 5.1.4)
 :001 > ActiveRecord::Base.connection.exec_query("select * from customer_entity limit 1;")
  SQL (14.5ms)  select * from customer_entity limit 1;
 => #<ActiveRecord::Result:0x007f8391576d10 @columns=["entity_id", "entity_type_id", "attribute_set_id", "website_id", "email", "group_id", "increment_id", "store_id", "created_at", "updated_at", "is_active"], @rows=[[3, 1, 0, 1, "3@3.net", 7, "", 1, 2010-08-23 22:04:48 UTC, 2010-12-21 18:00:09 UTC, 1]], @hash_rows=nil, @column_types={}> 
 :007 > 
```

If anything explodes, it's likely your db config is wonky (faulty tunnel, creds don't match what's in config/database.yml, MAGE_RW_PASSWORD not set, etc).

If your environment variable is set, but you get this error

```
λ ~/birchbox/graphql_mongo_product_api/ master* bin/rails console                                                                                                          
(erb):17:in `fetch': Cannot load `Rails.application.database_configuration`:
key not found: "MAGE_RW_PASSWORD" (KeyError)
```

It may be due to `spring` caching stuff. Try `spring stop`.

### Generating models

for this little project, we're not doing migrations (working with an existing legacy db) nor fixtures; so I've been using this command to at least put the right files in the right place (note that `rails` is now in `bin`):

```bash
bin/rails g model User --no-migration --no-fixture
```

### Graphql interactive app

Since this project is API-only, you can't quite use the de-facto gem (https://github.com/rmosolgo/graphql-ruby) that would serve from the rails server; because the assets middleware is skipped (see [these](https://github.com/rmosolgo/graphql-ruby/issues/768) [issues](https://github.com/rmosolgo/graphiql-rails/issues/13)).

However, you _can_ use a standalone node app based on electron (https://github.com/skevy/graphiql-app), which I prefer since you can have it on your laptop and just point it at a dev box vs. being beholden to the same server as the actual API. If you're on Mac and have node installed, it should be as easy as:

```
brew cask install graphiql
```

And then you only need to open GraphiQL.app and then point to your rails server's graphql root (by default: http://localhost:3000/graphql):

## References

Followed these tutorials loosely:

* https://blog.codeship.com/how-to-implement-a-graphql-api-in-rails/
* https://medium.com/@DrawandCode/building-a-graphql-api-in-rails-part-start-coding-8b1de6d75041

But the graphql documentation was incredible: http://graphql-ruby.org/types/introduction.html (+ the autodocs: http://www.rubydoc.info/gems/graphql/1.7.8/GraphQL/ObjectType).

