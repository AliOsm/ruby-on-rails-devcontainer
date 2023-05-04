# Ruby on Rails Devcontainer
Ruby on Rails devcontainer setup that includes Ruby, Ruby on Rails, PostgreSQL, Redis, MeiliSearch, Memcached, and Firefox to run system tests

## Pre-requisits

- [VSCode](https://code.visualstudio.com)
- [Docker Desktop](https://www.docker.com/products/docker-desktop)

## What are we setting up in this devcontainer?

Softwares:
- Latest version of [Git](https://git-scm.com) version control system
- Version `3.2.0` of [Ruby](https://www.ruby-lang.org) programming language
- Version `19` of [NodeJS](https://nodejs.org) JavaScript runtime environment
- [PostgreSQL](https://www.postgresql.org) database based on the latest official docker image
- [Redis](https://redis.io) in-memory key-value store based on the latest official docker image
- [MeiliSearch](https://www.meilisearch.com) search engine based on the latest official docker image
- [Memcached](https://memcached.org) in-memory key-value store based on the latest official docker image
- [Firefox](https://www.mozilla.org/en-US/firefox) browser to run system tests
- [`postgresql-client`](https://www.postgresql.org/docs/current/app-psql.html)

Extensions:
- [ANSI Colors](https://marketplace.visualstudio.com/items?itemName=iliazeus.vscode-ansi)
- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- [ERB Linter](https://marketplace.visualstudio.com/items?itemName=manuelpuyol.erb-linter)
- [Git Blame](https://marketplace.visualstudio.com/items?itemName=waderyan.gitblame)
- [GitHub Theme](https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme)
- [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
- [Output Colorizer](https://marketplace.visualstudio.com/items?itemName=IBM.output-colorizer)
- [Rails DB Schema](https://marketplace.visualstudio.com/items?itemName=aki77.rails-db-schema)
- [Rails](https://marketplace.visualstudio.com/items?itemName=bung87.rails)
- [Ruby Solargraph](https://marketplace.visualstudio.com/items?itemName=castwide.solargraph)
- [Ruby Test Explorer](https://marketplace.visualstudio.com/items?itemName=connorshea.vscode-ruby-test-adapter)
- [Ruby](https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby)
- [SQLTools PostgreSQL/Cockroach Driver](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools-driver-pg)
- [SQLTools](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)
- [Test Explorer UI](https://marketplace.visualstudio.com/items?itemName=hbenl.vscode-test-explorer)
- [VSCode Ruby](https://marketplace.visualstudio.com/items?itemName=wingrunr21.vscode-ruby)
- [ruby-rubocop-revived](https://marketplace.visualstudio.com/items?itemName=LoranKloeze.ruby-rubocop-revived)
- [vscode-gemfile](https://marketplace.visualstudio.com/items?itemName=bung87.vscode-gemfile)
- [vscode-icons](https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons)

## How to use?

Copy the `.devcontainer` directory into your Ruby on Rails project root directory and open it inside VSCode, then you will be able to use devcontainers as documented [here](https://code.visualstudio.com/docs/devcontainers/tutorial).

## Things to be aware of

### Automatic setup

This devcontainer setup does the following for you while building the image:
- Runs `gem update --system`
- Runs `bundle install`
- Runs `rails db:prepare`
- Adds `.devcontainer/launch.json` file to `.vscode` directory to be able to run debugging inside VSCode

You can customize this behavior inside `.devcontainer/setup.sh` file.

### PostgreSQL

You need to set the `host` and `port` properties for your development and testing databases in `config/database.yml` like this:

```yml
development:
  <<: *default
  database: ror_project_development

  username: postgres
  password: postgres
  host: db
  port: 5432

test:
  <<: *default
  database: ror_project_test

  username: postgres
  password: postgres
  host: db
  port: 5432
```

This is required because the docker service for PostgreSQL is named as `db` inside `.devcontainer/docket-compose.yml`, and you should access it by its name.

If you changed the `username` and/or `password` inside `config/database.yml`, then you will need to change them inside `.devcontainer/devcontainer.json` file to get `sqltools` extensions works properly.

### Redis

To connect to Redis in the development environment, you need to instantiate the connection like this:

```ruby
redis = Redis.new(url: ENV['REDIS_URL'] || 'http://redis:6379')
```

You should define `REDIS_URL` in your production environment, while in development `http://redis:6379` will be used. This is required because the docker service for Redis is named as `redis` inside `.devcontainer/docket-compose.yml`, and you should access it by its name.

### MeiliSearch

Inside your `config/initializers/meilisearch.rb` initializer, make sure to set the `meilisearch_url` and `meilisearch_api_key` properties like this:

```ruby
MeiliSearch::Rails.configuration = {
  meilisearch_url: ENV['MEILISEARCH_HOST'] || 'http://meilisearch:7700',
  meilisearch_api_key: ENV['MEILISEARCH_KEY'] || 'LOCAL_TEST_KEY'
}
```

You should define `MEILISEARCH_HOST` and `MEILISEARCH_KEY` in your production environment, while in development `http://meilisearch:7700` and `LOCAL_TEST_KEY` will be used. This is required because the docker service for MeiliSearch is named as `meilisearch` inside `.devcontainer/docket-compose.yml`, and you should access it by its name.

If you changed the `meilisearch_api_key` to something different than `LOCAL_TEST_KEY`, make sure to update `.devcontainer/docker-compose.yml` also.

### Memcached

Make sure to change `config.cache_store = :memory_store` to `config.cache_store = :mem_cache_store` inside `config/environments/development.rb`. Also, you will need to enable caching in development by running `rails dev:cache` command.

No need to specify the Memcached server as it is already defined inside `.devcontainer/Dockerfile` like this `ENV MEMCACHE_SERVERS=memcached:11211`.

### Firefox

To use Firefox in your system tests instead of Chrome, you will need to change `using: :chrome` to `using: :headless_firefox` inside `test/application_system_test_case.rb` file.

## Notes

- This is just a development setup, make sure to setup these services in your production environment also if you are using them
- Rebuild your devcontainer image when you change any file inside `.devcontainer` directory
- Take a look at the installed extensions and modify the list as required
- Feel free to submit any change you feel it is benefitial to this repo :)
