FROM ruby:3.1-slim

EXPOSE 4500

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    default-libmysqlclient-dev \
    default-mysql-client \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /usr/src/app

RUN gem install bundler

ENTRYPOINT ["infra/docker/scripts/entrypoint.sh"]
CMD ["bundle", "exec", "rspec"]
