defmodule CivicFlux.Domain.Aggregates.IssueAggregator do
  @moduledoc """
  Aggregate pentru o problemă raportată de cetățean.
  """

  defstruct [
    :id,
    :description,
    :location,
    :status
  ]

  @doc """
  Error tuples returned by this module:

    * `{:error, :invalid_id}` - The provided issue ID is invalid or missing.
    * `{:error, :already_reported}` - The issue has already been reported.
  """

  alias __MODULE__
  alias CivicFlux.Domain.Commands.ReportIssue
  alias CivicFlux.Domain.Events.IssueReported

  def execute(%IssueAggregator{id: nil}, %ReportIssue{id: nil}), do: {:error, :invalid_id}

  def execute(%IssueAggregator{id: nil}, %ReportIssue{id: id, description: desc, location: loc}) do
    {:ok, [%IssueReported{id: id, description: desc, location: loc}]}
  end

  def execute(%IssueAggregator{}, %ReportIssue{}), do: {:error, :already_reported}

  def apply(%IssueAggregator{} = state, %IssueReported{id: id, description: desc, location: loc}) do
    %IssueAggregator{state | id: id, description: desc, location: loc, status: "in_progress"}
  end
end
