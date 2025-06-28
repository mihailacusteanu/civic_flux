defmodule CivicFlux.Router do
  use Commanded.Commands.Router

  alias CivicFlux.Domain.Aggregates.Issue
  alias CivicFlux.Domain.Commands.ReportIssue

  identify Issue, by: :id, prefix: "issue-"

  dispatch [ReportIssue], to: Issue
end
