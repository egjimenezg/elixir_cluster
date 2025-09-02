ARG ELIXIR_VERSION=1.18.4
ARG OTP_VERSION=26.0.2
ARG DEBIAN_VERSION=bullseye-20250811
ARG BUILDER_IMG="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMG="debian:${DEBIAN_VERSION}"

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

RUN mkdir config

COPY config/config.exs config/${MIX_ENV}.exs config/

RUN mix deps.compile

COPY priv priv

COPY lib lib

COPY assets assets

# Compile the release
RUN mix compile

# Compile assets
RUN mix assets.deploy

COPY config/runtime.exs config/

COPY rel rel

RUN mix release

FROM ${RUNNER_IMG} AS runner

RUN apt-get update -y \
  && apt-get install -y libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"

WORKDIR "/app"
RUN chown nobody /app

ENV MIX_ENV="prod"

COPY --from=builder \
     --chown=nobody:root /app/_build/${MIX_ENV}/rel/ecs_elixir_cluster ./

USER nobody

CMD [ "/app/bin/server" ]
