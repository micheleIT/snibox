FROM ruby:2.6.10-alpine3.14

RUN apk add --no-cache -t build-dependencies \
  build-base \
  postgresql-dev \
  && apk add --no-cache \
  git \
  tzdata \
  nodejs \
  yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./

ENV RAILS_ENV production
ENV RACK_ENV production
ENV NODE_ENV production

RUN gem install bundler && bundle config set --local without 'development test' && bundle install --deployment

COPY . ./

RUN SECRET_KEY_BASE=docker ./bin/rake assets:precompile && ./bin/yarn cache clean
