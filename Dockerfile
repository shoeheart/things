FROM ruby/2.5.1-alpine

# Install prerequisites
RUN apk --update --no-cache add \
    bash \
    build-base \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev \
    postgresql-client \
    freetds-dev \
    tzdata \
    curl \
    nginx \
    zip \
    p7zip \
    gzip \
    tar \
    git \
    && gem install bundler \
    && bundle config build.nokogiri --use-system-libraries \
    && mkdir /app \
    && mkdir -p /app/tmp/sockets && mkdir -p /app/tmp/pids

ENV RAILS_ENV=production
ENV TERM xterm
ENV DOCKERIZED=true
ENV RAILS_LOG_TO_STDOUT=true

WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
COPY vendor/gems /app/vendor/gems
RUN bundle check || RAILS_ENV=production bundle install --without development test -j4

# Set the instance of this version of mvp via -build-arg INSTANCE=$INSTANCE
ARG INSTANCE
ENV INSTANCE=${INSTANCE}

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}

COPY . /app
ENV SECRET_KEY_BASE="$(openssl rand -hex 64)"

RUN rm -rf .git
RUN DB_ADAPTER=nulldb bundle exec rails assets:precompile
RUN rm -rf /app/node_modules

CMD ./entrypoint.sh
