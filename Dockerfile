FROM pbxx/docker-passenger-ruby-base:ruby-2.7.6-latest

ARG FOO=bar

USER root

RUN apt-get update \
  && apt-get install -y --no-install-recommends --fix-missing \
      wget \
      nano \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Switch to the app user for app installation
USER app

# Define where our application will live inside the image
ENV HOMEDIR /home/app/
WORKDIR $HOMEDIR/sendgrid_toolkit

# Set environment
ENV RUBYOPT='-W:no-deprecated -W:no-experimental'

COPY --chown=app:app . .

# Install rubygems and bundler
RUN rm -rf .bundle
RUN gem update --system 3.4.22
RUN gem install bundler -v 2.4.22

# Install gems
ARG CACHEBUST
RUN bundle install --full-index

USER root
