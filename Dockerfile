FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /cut-api
WORKDIR /cut-api
ADD Gemfile /cut-api/Gemfile
ADD Gemfile.lock /cut-api/Gemfile.lock
RUN bundle install
ADD . /cut-api
