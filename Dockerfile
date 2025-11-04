# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t myapp .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name myapp myapp

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.6
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Base packages (runtime)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl ffmpeg libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# -------- Build stage --------
FROM base AS build

# Build deps (gems / node)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev node-gyp pkg-config python-is-python3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Node (npm only)
ARG NODE_VERSION=20.19.3
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    rm -rf /tmp/node-build-master

# Gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Node modules (npm)
COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

# App code
COPY . .

# Bootsnap (app code)
RUN bundle exec bootsnap precompile app/ lib/

# Assets precompile (requires node_modules present)
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Drop node_modules to slim runtime image (esbuild/cssbundlingはビルド時のみ使用)
RUN rm -rf node_modules

# -------- Final stage --------
FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

CMD ["bash","-lc","bundle exec puma -C config/puma.rb"]
