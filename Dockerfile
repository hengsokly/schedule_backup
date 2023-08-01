FROM ruby:2.7.2

LABEL maintainer="Kakada CHHEANG <kakada@instedd.org>"

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  apt-get update -qq && \
  apt-get install -y nodejs yarn cron && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# -----Install postgresql 12 on debian 11---start
# In ruby 2.7.2 depends on debian 11 that has default postgresql 11
# When backup db, it is incompatible with postgresql version, so need to install postgresql 12
# Create the file repository configuration:
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Update the package lists:
RUN apt-get update

# Install the latest version of PostgreSQL.
RUN apt-get -y install postgresql-client-12

# -----Install postgresql 12 on debian 11---end

ADD Backup/config.rb /root/Backup/config.rb
ADD Backup/models/model.rb /root/Backup/models/

# Plan to remove
COPY hello-cron /etc/cron.d/hello-cron
RUN chmod 0744 /etc/cron.d/hello-cron
RUN crontab /etc/cron.d/hello-cron
RUN touch /var/log/cron.log

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler:2.1.4

# This gem should not be installed as a dependency of another application. If you put this gem in Gemfile, you won't see it production mode.
RUN gem install backup -v5.0.0.beta.3
RUN gem install whenever

# Install the application
COPY . /app

# Generate version file if available
RUN if [ -d .git ]; then git describe --always > VERSION; fi

ENV RAILS_LOG_TO_STDOUT=true
ENV RACK_ENV=production
ENV RAILS_ENV=production

CMD bash -c "bundle exec whenever --update-crontab && cron -f"
