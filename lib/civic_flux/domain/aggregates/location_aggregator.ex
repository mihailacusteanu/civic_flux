defmodule CivicFlux.Domain.Aggregates.LocationAggregator do
  @moduledoc """
  Location aggregate that handles AddToMap and LocationNeedsAttention commands.
  """
  defstruct [
    :id,
    :priority_status,
    :info
  ]

  alias CivicFlux.Domain.Commands.AddToMap
  alias CivicFlux.Domain.Commands.LocationNeedsAttention
  alias CivicFlux.Domain.Events.LocationAddedToMap
  alias CivicFlux.Domain.Events.LocationMarkedForAttention

  def execute(%__MODULE__{id: nil}, %AddToMap{location: location}) do
    {:ok, [%LocationAddedToMap{
      location: location,
      added_at: DateTime.utc_now()
    }]}
  end

  def execute(%__MODULE__{}, %AddToMap{location: location}) do
    {:ok, [%LocationAddedToMap{
      location: location,
      added_at: DateTime.utc_now()
    }]}
  end

  def execute(%__MODULE__{}, %LocationNeedsAttention{location: location}) do
    {:ok, [%LocationMarkedForAttention{
      location: location,
      marked_at: DateTime.utc_now()
    }]}
  end

  def apply(%__MODULE__{} = state, %LocationAddedToMap{location: location}) do
    %__MODULE__{state |
      id: location,
      priority_status: "normal"
    }
  end

  def apply(%__MODULE__{} = state, %LocationMarkedForAttention{location: _location, reason: reason}) do
    %__MODULE__{state |
      priority_status: "needs_attention",
      info: reason
    }
  end
end
