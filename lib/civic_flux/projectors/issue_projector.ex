defmodule CivicFlux.Projectors.IssueProjector do
  @moduledoc """
  Projector for issues.
  """
  use Commanded.Projections.Ecto,
    name: "IssueProjector",
    application: CivicFlux.App,
    repo: CivicFlux.Repo

  alias CivicFlux.Domain.Events.IssueReported
  alias CivicFlux.ReadModels.Issue

  project(%IssueReported{id: id, description: desc, location: loc}, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :issue, %Issue{
      id: id,
      description: desc,
      location: loc
    })
  end)
end
