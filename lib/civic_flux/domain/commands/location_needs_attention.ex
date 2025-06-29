defmodule CivicFlux.Domain.Commands.LocationNeedsAttention do
  @moduledoc """
  Command to mark a location as needing attention due to multiple issues.
  """
  @derive Jason.Encoder
  defstruct [
    :location,
    :reason
  ]
end
