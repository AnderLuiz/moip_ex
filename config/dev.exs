use Mix.Config


config :moip_ex,
  token: System.get_env("TOKEN"),
  api_key: System.get_env("API_KEY"),
  env: :sandbox

#import_config "dev.secret.exs"
