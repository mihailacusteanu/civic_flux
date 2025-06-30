defmodule CivicFlux.Domain.Aggregates.IssueAggregatorTest do
  use ExUnit.Case, async: true

  alias CivicFlux.Domain.Aggregates.IssueAggregator
  alias CivicFlux.Domain.Commands.ReportIssue
  alias CivicFlux.Domain.Events.IssueReported

  describe "report issue" do
    test "should emit IssueReported event when valid data is provided" do
      issue = %IssueAggregator{}

      cmd = %ReportIssue{
        id: "ISSUE-1",
        description: "Groapă în asfalt",
        location: "Strada Exemplu 123"
      }

      expected_event = %IssueReported{
        id: "ISSUE-1",
        description: "Groapă în asfalt",
        location: "Strada Exemplu 123"
      }

      assert {:ok, [^expected_event]} = IssueAggregator.execute(issue, cmd)
    end
  end
end
