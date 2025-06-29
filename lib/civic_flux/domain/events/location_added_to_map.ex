defmodule CivicFlux.Domain.Events.LocationAddedToMap do
  @moduledoc """
  Event emitted when a location is added to the map.
  """
  @derive Jason.Encoder
  defstruct [
    :location,
    :added_at
  ]
end
