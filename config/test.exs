use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vlt_labs_wizard, VltLabsWizard.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :vlt_labs_wizard, VltLabsWizard.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "vlt_labs_wizard_test",
  hostname: "localhost",
  ownership_timeout: 999999,
  pool: Ecto.Adapters.SQL.Sandbox
