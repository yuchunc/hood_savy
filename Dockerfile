FROM ubuntu:18.04 AS base

WORKDIR /app

# install ubuntu packages
RUN apt-get update -q \
 && apt-get install -y \
    git \
    curl \
    locales \
    build-essential \
    autoconf \
    libncurses5-dev \
    libwxgtk3.0-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libpng-dev \
    libssh-dev \
    unixodbc-dev \
 && apt-get clean

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# install asdf and its plugins
# ASDF will only correctly install plugins into the home directory as of 0.7.5
# so .... Just go with it.
ENV ASDF_ROOT /root/.asdf
ENV PATH "${ASDF_ROOT}/bin:${ASDF_ROOT}/shims:$PATH"

RUN git clone https://github.com/asdf-vm/asdf.git ${ASDF_ROOT} --branch v0.7.5  \
 && asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang \
 && asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir \
 && asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs \
 && ${ASDF_ROOT}/plugins/nodejs/bin/import-release-team-keyring

# set the locale
COPY .tool-versions .
RUN asdf install

# install local Elixir hex and rebar
RUN mix local.hex --force \
 && mix local.rebar --force

FROM base

WORKDIR /app

COPY . .

ARG RELEASE_VERSION=0.1.0
ENV MIX_ENV prod

# install deps

RUN mix deps.get --only prod

# install frontend deps

RUN npm install --prefix assets \
  && npm run deploy --prefix assets

# build mix release

RUN mix phx.digest \
  && mix systemd.generate \
  && mix release \
  && cp _build/prod/systemd/lib/systemd/system/hood-savy.service _build/prod/rel/hood_savy \
  && tar cf release-${RELEASE_VERSION}.tar -C _build/prod/rel/hood_savy .
