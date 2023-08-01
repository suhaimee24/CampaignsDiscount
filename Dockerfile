FROM ruby:3.1.2
RUN apt-get update -qq 
WORKDIR /campaigns_discount
COPY . /campaigns_discount
COPY Gemfile /campaigns_discount/Gemfile
COPY Gemfile.lock /campaigns_discount/Gemfile.lock
RUN bundle install

EXPOSE $RAILS_PORT

CMD ["rails", "server", "-b", "0.0.0.0"]