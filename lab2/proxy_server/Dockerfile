FROM elixir:1.7.4

EXPOSE 8085

RUN mix local.hex --force && \
    mix local.rebar --force 
 
WORKDIR /app
ADD . .

RUN mix deps.get && \
    mix deps.compile && \
    mix clean && mix deps.clean --unused

CMD ["mix", "run", "--no-halt"]

