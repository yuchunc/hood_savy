# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

# database_url =
#   System.get_env("DATABASE_URL") ||
#     raise """
#     environment variable DATABASE_URL is missing.
#     For example: ecto://USER:PASS@HOST/DATABASE
#     """

db_host = System.get_env("DB_HOST")
db_user = System.get_env("DB_USER")
db_pw = System.get_env("DB_USER")

config :hood_savy, HoodSavy.Repo,
  # url: database_url,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PW"),
  database: "hood_savy_prod",
  hostname: System.get_env("DB_HOST"),
  pool_size: String.to_integer(System.get_env("DB_POOL") || "10")

secret_key_base =
  System.get_env("SECRET_KEY") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :hood_savy, HoodSavyWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:

config :hood_savy, HoodSavyWeb.Endpoint, server: true

# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.