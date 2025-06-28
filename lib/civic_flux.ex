defmodule CivicFlux do
  @moduledoc """
  The CivicFlux application serves as the entry point for the Commanded event-sourced system.
  """
  use Commanded.Application, otp_app: :civic_flux

end
