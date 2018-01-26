# README

## Development

### Prerrequisites: 
* Ruby version: 2.2.2.

* System dependencies: before bundling, make sure you have xcode command line tools installed (`xcode-select install` will get you there)

* Configuration: in development you need to provide an environment variable called MAGE_RW_PASSWORD (export it in a terminal session or put it in some *rc file) with the password for your dev box's legacy database. If you want to test out mutations, also set the `MAGE_URI` environment variable to be able to talk directly to the legacy api.

* Database initialization: the default database.yml assumes you're tunneling back to your dev box's copy of the legacy database on port 3316; if you set up your tunnels in your ssh config (instead of running ad-hoc) you need to have a session open (ssh to your dev box on another terminal tab).

One Janky thing I did is that I just created a small bash script called `env.sh` to load my env vars, e.g.

```
λ ~/birchbox/graphql_mongo_product_api/ master cat env.sh 
export MAGE_URI="https://www.luis-beta.dev.birchbox.com"
export MAGE_RW_PASSWORD=wouldntyouliketoknow
export LEGACY_SOLR_URI="http://solr.luis-beta.dev.birchbox.com:8080/solr440/products"
```

And then just `source env.sh` to have them available (adding a new env var requires the spring preloader to be stopped, if not, rails is not going to find it and you'll pull your hair). There's gems for this kind of thing: https://github.com/bkeepers/dotenv and of course for the actual secrets (vs. env-dependent config values), one can resort to [rails's secrets.yml](http://guides.rubyonrails.org/4_1_release_notes.html#config-secrets-yml)

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

### Check your solr connection

```bash
λ ~/birchbox/graphql_mongo_product_api/ master bin/rails console
Running via Spring preloader in process 21761
Loading development environment (Rails 5.1.4)
2.2.2 :001 > solr_url = ENV["LEGACY_SOLR_URI"]
 => "http://solr.luis-beta.dev.birchbox.com:8080/solr440/products" 
2.2.2 :002 > solr = RSolr.connect url: solr_url
 => #<RSolr::Client:0x007fc6a1e70b20 @uri=#<URI::HTTP http://solr.luis-beta.dev.birchbox.com:8080/solr440/products/>, @proxy=nil, @connection=nil, @update_format=RSolr::JSON::Generator, @update_path="update", @options={:url=>"http://solr.luis-beta.dev.birchbox.com:8080/solr440/products"}> 
2.2.2 :003 > r = solr.get 'select', params: {q: "id:111", fl: "id,product_name"}
 => {"responseHeader"=>{"status"=>0, "QTime"=>0, "params"=>{"fl"=>"id,product_name", "q"=>"id:111", "wt"=>"json"}}, "response"=>{"numFound"=>1, "start"=>0, "docs"=>[{"id"=>"111", "product_name"=>"blowPro Blow Up Thickening Mist"}]}}
```

If anything explodes, it's likely your db config is wonky (faulty tunnel, creds don't match what's in config/database.yml, MAGE_RW_PASSWORD not set, etc).

If your environment variable is set, but you get this error

```
λ ~/birchbox/graphql_mongo_product_api/ master* bin/rails console                                                                                                          
(erb):17:in `fetch': Cannot load `Rails.application.database_configuration`:
key not found: "MAGE_RW_PASSWORD" (KeyError)
```

It may be due to `spring` caching stuff. Try `spring stop`.

### Importing development data

There's a janky way to import products from the legacy data store (mysql+solr) to mongo:

```ruby
LegacyProduct.export_to_mongo(limit: 50)
```

Will take the 50 latest products in your legacy database, look them up in solr (not all of them will be there) and put them into your local mongo `products` collection. `LegacyProduct.export_to_mongo(id: 111)` will do the same for the product whose ID is specified.

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

