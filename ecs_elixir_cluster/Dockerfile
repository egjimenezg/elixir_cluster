ARG ELIXIR_VERSION=1.18.4
ARG OTP_VERSION=26.0.2
ARG DEBIAN_VERSION=bullseye-20250811
ARG BUILDER_IMG="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"

FROM ${BUILDER_IMG} AS builder

RUN apt-get update && apt-get install -y \
  git \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV="prod"
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
