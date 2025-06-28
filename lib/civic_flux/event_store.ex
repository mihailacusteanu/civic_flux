defmodule CivicFlux.EventStore do
  @moduledoc """
  The EventStore module for CivicFlux, responsible for managing event sourcing.
  It uses the Commanded library to handle events and commands in the application.
  """
  use EventStore, otp_app: :civic_flux
end
