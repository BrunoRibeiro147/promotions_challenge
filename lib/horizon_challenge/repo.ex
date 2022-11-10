defmodule HorizonChallenge.Repo do
  use Ecto.Repo,
    otp_app: :horizon_challenge,
    adapter: Ecto.Adapters.Postgres
end
