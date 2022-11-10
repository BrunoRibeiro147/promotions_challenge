import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :horizon_challenge, HorizonChallenge.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "horizon_challenge_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :horizon_challenge, HorizonChallengeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "PEu6n/rRf/Tpg6lp3DfJMTCYxG2n46Rd3J5RovvSdNAhUIPw7O/x42w8h6OJ3ZnR",
  server: false

# In test we don't send emails.
config :horizon_challenge, HorizonChallenge.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
