defmodule CivicFlux.Repo do
  use Ecto.Repo,
    otp_app: :civic_flux,
    adapter: Ecto.Adapters.Postgres
end
