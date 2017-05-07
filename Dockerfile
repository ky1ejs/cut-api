FROM ruby:2.3.0

# update apt-get
RUN apt-get update -qq

# for postgres
RUN apt-get install -y build-essential libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

ENV APP_HOME /cut-api
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile $APP_HOME
ADD Gemfile.lock $APP_HOME
RUN gem install bundler
RUN bundle install

ADD . $APP_HOME

RUN bundle exec whenever --update-crontab

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
