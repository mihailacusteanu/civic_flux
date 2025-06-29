defmodule CivicFlux.Domain.Commands.AddToMap do
  @moduledoc """
  Command to add an issue to the map.
  """

  @derive Jason.Encoder
  defstruct [
    :description,
    :location
  ]
end
