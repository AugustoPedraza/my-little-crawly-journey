FROM elixir:latest

# Install debian packages
RUN apt-get update && \
    apt-get install --yes build-essential inotify-tools postgresql-client git && \
    apt-get clean

ADD . /app

# Install Phoenix packages
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force hex phx_new

# Make the entrypoint.sh script executable
RUN chmod +x app/entrypoint.sh


WORKDIR /app

RUN mix deps.get

# Expose the port that the Phoenix app runs on
EXPOSE 4000

# Specify the entrypoint script
ENTRYPOINT ["./entrypoint.sh"]
