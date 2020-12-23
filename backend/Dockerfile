FROM ruby:2.7.2

# ONLY for development container
RUN mkdir -m 777 /home/user
ENV HOME /home/user

WORKDIR /app
COPY Gemfile Gemfile.lock ./
ARG ENV="prod"
RUN bundle install \
    $(test "$ENV" = "prod" && echo '--without test development --deployment')

COPY . /app

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
