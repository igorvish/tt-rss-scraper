FROM ruby:2.3.1

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
  build-essential               `# Many Ruby gems and NPM packages contain native extensions and require a compiler` \
  nodejs                        `# The Rails asset compiler requires a Javascript runtime` \
  libxml2-dev libxslt1-dev      `# For nokogiri.` \
  libpq-dev                     `# For postgres and pg.` \
  `#postgresql-client`             `# Pg client for debug` \
  && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8
ENV APP_HOME /app

RUN mkdir $APP_HOME

WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN git config --global url."https://".insteadOf git://
RUN bundle install --jobs 4 --retry 5

ADD . $APP_HOME
