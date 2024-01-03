FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev vim cron postgresql-client

ADD Backup/config.rb /root/Backup/config.rb
ADD Backup/models/ /root/Backup/models/
ADD backups/ /root/backups

RUN mkdir /app
WORKDIR /app
COPY . /app
RUN bundle install

CMD bash -c "bundle exec whenever --update-crontab && cron -f"
