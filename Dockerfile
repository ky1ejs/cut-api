FROM ruby:2.3.0

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /cut-api
WORKDIR /cut-api

ONBUILD COPY Gemfile /cut-api/Gemfile
ONBUILD COPY Gemfile.lock /cut-api/Gemfile.lock
ONBUILD RUN bundle install

ONBUILD COPY . /cut-api

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN apt-get update && apt-get install -y postgresql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
