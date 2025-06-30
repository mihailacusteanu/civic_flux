defmodule CivicFlux.Router do
  use Commanded.Commands.Router

  alias CivicFlux.Domain.Aggregates.IssueAggregator
  alias CivicFlux.Domain.Aggregates.LocationAggregator
  alias CivicFlux.Domain.Commands.ReportIssue
  alias CivicFlux.Domain.Commands.AddToMap
  alias CivicFlux.Domain.Commands.LocationNeedsAttention

  identify(IssueAggregator, by: :id, prefix: "issue-")
  identify(LocationAggregator, by: :location)

  dispatch([ReportIssue], to: IssueAggregator)
  dispatch([AddToMap, LocationNeedsAttention], to: LocationAggregator)
end
