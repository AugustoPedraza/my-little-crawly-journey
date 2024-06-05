#!/bin/bash
# Docker entrypoint script.


# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  mix ecto.create
  mix ecto.migrate
  mix run priv/repo/seeds.exs
  echo "Database $PGDATABASE created."
fi

exec mix phx.server
