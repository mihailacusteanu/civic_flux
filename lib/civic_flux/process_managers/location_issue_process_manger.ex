defmodule CivicFlux.ProcessManagers.LocationIssueProcessManager do
  @moduledoc """
  Process Manager that coordinates the management of issues at a location.
  Decides whether to add the location to the map or mark it as needing attention.
  """

  use Commanded.ProcessManagers.ProcessManager,
    name: "LocationIssueProcessManager",
    application: CivicFlux.App

  @derive Jason.Encoder
  defstruct [
    :location,
    :recent_issues,
    :last_issue_at
  ]

  alias CivicFlux.Domain.Events.IssueReported
  alias CivicFlux.Domain.Commands.AddToMap
  alias CivicFlux.Domain.Commands.LocationNeedsAttention

  def interested?(%IssueReported{location: location}), do: {:start, location}

  def handle(%__MODULE__{} = state, %IssueReported{location: location}) do
    new_count = (state.recent_issues || 0) + 1

    if new_count < 10 do
      [%AddToMap{location: location}]
    else
      [
        %LocationNeedsAttention{
          location: location,
          reason: "Threshold exceeded: #{new_count} issues reported at this location"
        }
      ]
    end
  end

  def apply(%__MODULE__{} = state, %IssueReported{location: location}) do
    %__MODULE__{
      state
      | location: location,
        recent_issues: (state.recent_issues || 0) + 1,
        last_issue_at: DateTime.utc_now()
    }
  end
end
