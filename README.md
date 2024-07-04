# Ruby on Rails DevContainer
Ruby on Rails DevContainer setup that includes Ruby, Ruby on Rails, Selenium, PostgreSQL, Redis, Memcached, and MeiliSearch.

## Pre-requisits

- [VSCode](https://code.visualstudio.com)
- [Docker](https://www.docker.com)

## What are we setting up in this DevContainer?

Softwares:
- [Ruby](https://www.ruby-lang.org) version `3.3.3`
- [NodeJS](https://nodejs.org) version `20.15.0` (or later)
- [Yarn](https://yarnpkg.com) version `1.22.22` (or later)
- [Zsh](https://www.zsh.org)
- [Git](https://git-scm.com)
- [Vim](https://www.vim.org)
- [Selenium](https://www.selenium.dev)
- [PostgreSQL](https://www.postgresql.org)
- [Redis](https://redis.io)
- [Memcached](https://memcached.org)
- [MeiliSearch](https://www.meilisearch.com)

Extensions:
- [Postman](https://marketplace.visualstudio.com/items?itemName=Postman.postman-for-vscode)
- [Rails DB Schema](https://marketplace.visualstudio.com/items?itemName=aki77.rails-db-schema)
- [Rails I18n](https://marketplace.visualstudio.com/items?itemName=aki77.rails-i18n)
- [Rails Partial](https://marketplace.visualstudio.com/items?itemName=aki77.rails-partial)
- [Tailwind CSS IntelliSense](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss)
- [vscode-gemfile](https://marketplace.visualstudio.com/items?itemName=bung87.vscode-gemfile)
- [GitLens — Git supercharged](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
- [Ruby ERB::Formatter](https://marketplace.visualstudio.com/items?itemName=elia.erb-formatter)
- [Run on Save](https://marketplace.visualstudio.com/items?itemName=emeraldwalk.RunOnSave)
- [ERB Linter](https://marketplace.visualstudio.com/items?itemName=manuelpuyol.erb-linter)
- [Stimulus LSP](https://marketplace.visualstudio.com/items?itemName=marcoroth.stimulus-lsp)
- [Live Preview](https://marketplace.visualstudio.com/items?itemName=ms-vscode.live-server)
- [SQLTools](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)
- [SQLTools PostgreSQL/Cockroach Driver](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools-driver-pg)
- [vscode-icons](https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons)
- [Git Blame](https://marketplace.visualstudio.com/items?itemName=waderyan.gitblame)
- [Shopify LSP](https://marketplace.visualstudio.com/items?itemName=Shopify.ruby-lsp)

## How to use?

Copy the `.devcontainer` directory into your Ruby on Rails project root directory and open it inside VSCode, then you will be able to use devcontainers as documented [here](https://code.visualstudio.com/docs/devcontainers/tutorial).

## Things to be aware of

### Automatic setup

This DevContainer setup does the following for you while building the image:
- Runs `gem update --system`
- Runs `bundle`
- Runs `yarn`
- Runs `rails db:create db:migrate db:seed`

You can customize this behavior inside `.devcontainer/setup.sh` file.

### Formatting

This DevContainer setup assumes that you are using `erb-lint`, `erb-formatter`, and `i18n-tasks` gems, as it sets up formatting commands using `Run on Save` VSCode extension to format `erb`, `css`, and `yml` files. See [devcontainer.json](./.devcontainer/devcontainer.json) lines 83-106 for more details.

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

This is required because the docker service for PostgreSQL is named `db` inside `.devcontainer/docker-compose.yml`, and you should access it by its name.

If you changed the `username` and/or `password` inside `config/database.yml`, then you will need to change them inside `.devcontainer/devcontainer.json` file to get `sqltools` extensions works properly.

### Redis

To connect to Redis in the development environment, you need to instantiate the connection like this:

```ruby
redis = Redis.new(url: ENV['REDIS_URL'] || 'http://redis:6379')
```

You should define `REDIS_URL` in your production environment, while in development `redis://redis:6379` will be used. This is required because the docker service for Redis is named `redis` inside `.devcontainer/docker-compose.yml`, and you should access it by its name.

### Memcached

Make sure to change `config.cache_store = :memory_store` to `config.cache_store = :mem_cache_store` inside `config/environments/development.rb`. Also, you will need to enable caching in development by running `rails dev:cache` command.

No need to specify the Memcached server as it is already defined inside `.devcontainer/Dockerfile` like this `ENV MEMCACHE_SERVERS=memcached:11211`.

### MeiliSearch

Inside your `config/initializers/meilisearch.rb` initializer, make sure to set the `meilisearch_url` and `meilisearch_api_key` properties like this:

```ruby
MeiliSearch::Rails.configuration = {
  meilisearch_url: ENV['MEILISEARCH_HOST'] || 'http://meilisearch:7700',
  meilisearch_api_key: ENV['MEILISEARCH_KEY'] || 'LOCAL_TEST_KEY'
}
```

You should define `MEILISEARCH_HOST` and `MEILISEARCH_KEY` in your production environment, while in development `http://meilisearch:7700` and `LOCAL_TEST_KEY` will be used. This is required because the docker service for MeiliSearch is named `meilisearch` inside `.devcontainer/docker-compose.yml`, and you should access it by its name.

If you changed the `meilisearch_api_key` to something different than `LOCAL_TEST_KEY`, make sure to update `.devcontainer/docker-compose.yml` also.

## Notes

- This is just a development setup, make sure to setup these services in your production environment also if you are using them
- Rebuild your DevContainer image when you change any file inside `.devcontainer` directory
- Take a look at the installed extensions and modify the list as required
- This could be used in GitHub Codespaces easily with a single click
- Feel free to submit any change you feel it is benefitial to this repo :)
