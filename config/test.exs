use Mix.Config

# Configure your database
config :bill, Bill.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "test",
  password: "test",
  database: "bill_test",
  hostname: "localhost",
 #poolsize: 10,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bill, BillWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
