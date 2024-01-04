FROM ruby:3.3.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev vim cron postgresql-client

# fix installing backup gem on the ruby 3.3.0
RUN gem install ovirt-engine-sdk:4.4.1 -- --with-cflags=-Drb_cData=rb_cObject

ADD Backup/config.rb /root/Backup/config.rb
ADD Backup/models/ /root/Backup/models/
ADD backups/ /root/backups

RUN mkdir /app
WORKDIR /app
COPY . /app
RUN bundle install

CMD bash -c "bundle exec whenever --update-crontab && cron -f"
