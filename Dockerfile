FROM --platform=linux/amd64 ruby:3.2.2

RUN apt-get update -qq && apt-get install -y \
  libvips \
  build-essential \
  libpq-dev \
  nodejs \
  yarn

ENV app_path /docker_app
RUN mkdir ${app_path}
WORKDIR ${app_path}

COPY ./Gemfile ${app_path}/Gemfile
COPY ./Gemfile.lock ${app_path}/Gemfile.lock

RUN bundle install
COPY . ${app_path}

COPY ./start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["sh", "/start.sh"]
