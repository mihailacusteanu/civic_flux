defmodule CivicFlux.Domain.Aggregates.Issue do
  @moduledoc """
  Aggregate pentru o problemă raportată de cetățean.
  """

  defstruct [
    :id,
    :description,
    :location,
    :status
  ]

  alias __MODULE__
  alias CivicFlux.Domain.Commands.ReportIssue
  alias CivicFlux.Domain.Events.IssueReported

  def execute(%Issue{id: nil}, %ReportIssue{id: nil}), do: {:error, :invalid_id}

  def execute(%Issue{id: nil}, %ReportIssue{id: id, description: desc, location: loc}) do
    {:ok, [%IssueReported{id: id, description: desc, location: loc}]}
  end

  def execute(%Issue{}, %ReportIssue{}), do: {:error, :already_reported}

  def apply(%Issue{} = state, %IssueReported{id: id, description: desc, location: loc}) do
    %Issue{state | id: id, description: desc, location: loc, status: "deschis"}
  end
end
