defmodule CivicFlux.App do
  @moduledoc """
  The CivicFlux event-sourced application (Commanded root module).
  """
  use Commanded.Application, otp_app: :civic_flux

  router(CivicFlux.Router)
end
