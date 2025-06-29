defmodule CivicFlux.Domain.Events.LocationMarkedForAttention do
  @moduledoc """
  Event emitted when a location needs attention due to multiple issues.
  """
  @derive Jason.Encoder
  defstruct [
    :location,
    :reason,
    :marked_at
  ]
end
