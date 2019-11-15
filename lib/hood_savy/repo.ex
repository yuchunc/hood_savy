defmodule HoodSavy.Repo do
  use Ecto.Repo,
    otp_app: :hood_savy,
    adapter: Ecto.Adapters.Postgres
end
