# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.3
FROM ghcr.io/rails/devcontainer/images/ruby:$RUBY_VERSION

# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service.
# The value is a comma-separated list of allowed domains.
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.preview.app.github.dev,.app.github.dev,.ngrok-free.app"

# Memcached servers list.
ENV MEMCACHE_SERVERS=memcached:11211

RUN apt-get update \
    # Install additional OS packages.
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends curl software-properties-common \
    # Setup RustyWind
    && curl -LSfs https://avencera.github.io/rustywind/install.sh | sh -s -- --git avencera/rustywind \
    # Clean up.
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
