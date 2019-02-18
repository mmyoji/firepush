FROM ruby:2.6.1-alpine

RUN apk add \
  gcc \
  git \
  libc-dev \
  make

WORKDIR /app

COPY firepush.gemspec         /app/firepush.gemspec
COPY Gemfile                  /app/Gemfile
COPY lib/firepush/version.rb  /app/lib/firepush/version.rb

RUN bundle install

COPY . /app
