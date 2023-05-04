FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service
# The value is a comma-separated list of allowed domains.
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.preview.app.github.dev,.app.github.dev"

# Memcached servers list.
ENV MEMCACHE_SERVERS=memcached:11211

# Install additional OS packages and PostgreSQL client.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends postgresql-client software-properties-common

# Setup Firefox to do system testing.
RUN add-apt-repository ppa:mozillateam/ppa
RUN echo 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001\n' | sudo tee /etc/apt/preferences.d/mozilla-firefox
RUN apt update
RUN apt -y install firefox
