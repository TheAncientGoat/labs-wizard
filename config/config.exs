# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :vlt_labs_wizard,
  ecto_repos: [VltLabsWizard.Repo]

# Configures the endpoint
config :vlt_labs_wizard, VltLabsWizard.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: VltLabsWizard.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: VltLabsWizard.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :vlt_labs_wizard, VltLabsWizard.Bot.SlackScheduler,
  jobs: [
    # {"03 9 * * 1-5", fn -> VltLabsWizard.Bot.remind_mandays end}
  ]

config :ex_aws, :s3,
  region: System.get_env("AWS_REGION"),
  bucket: "labs-wizard" # if using Amazon S3

config :arc,
  storage: Arc.Storage.S3, # or Arc.Storage.Local
  asset_host: System.get_env("ASSET_HOST"),
  bucket: System.get_env("AWS_BUCKET") # if using Amazon S3

config :slack,
  enabled: System.get_env("SLACK_BOT_ENABLED"),
  api_token: System.get_env("SLACK_API_TOKEN")


# Admin Panel
config :ex_admin,
  repo: VltLabsWizard.Repo,
  module: VltLabsWizard.Web,    # MyProject.Web for phoenix >= 1.3.0-rc
  modules: [
    VltLabsWizard.ExAdmin.Dashboard,
    VltLabsWizard.ExAdmin.Department,
    VltLabsWizard.ExAdmin.ManDay,
    VltLabsWizard.ExAdmin.Employee,
    VltLabsWizard.ExAdmin.User,
    VltLabsWizard.ExAdmin.Project,
    VltLabsWizard.ExAdmin.Projects.Assignment,
    VltLabsWizard.ExAdmin.Projects.Feature,
    VltLabsWizard.ExAdmin.Finance.ManDayPurchase
  ]

config :mime, :types, %{
  "application/json" => ["json"]
}
Logger.add_backend {LoggerFileBackend, :debug}
Logger.configure_backend {LoggerFileBackend, :debug},
  path: "debug.log"

config :logger, :info,
  path: "info.log",
  level: :info

config :logger, :error,
  path: "error.log",
  level: :error

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :xain, :after_callback, {Phoenix.HTML, :raw}

config :guardian, Guardian,
  issuer: "LabsWizard",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: System.get_env("GUARDIAN_SECRET_KEY"),
  serializer: VltLabsWizard.Auth.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
