import Config

config :vo,
  cnpj_validator: Vo.Utils.Cnpj.CnpjMockValidator,
  cpf_validator: Vo.Utils.Cpf.CpfMockValidator

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :vo, Vo.Repo,
  username: "docker",
  password: "docker",
  hostname: "0.0.0.0",
  port: 5434,
  database: "vo_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vo, VoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "QtiIr/EOyLhNpp+8p3QWTL4k4cXX34Wfx6GCiCWOgZbf19/9gDCsCBAAE3/9iFok",
  server: false

# In test we don't send emails
config :vo, Vo.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
