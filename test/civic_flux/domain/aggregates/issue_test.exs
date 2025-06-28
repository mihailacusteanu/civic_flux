defmodule CivicFlux.Domain.Aggregates.IssueTest do
  use ExUnit.Case, async: true

  alias CivicFlux.Domain.Aggregates.Issue
  alias CivicFlux.Domain.Commands.ReportIssue
  alias CivicFlux.Domain.Events.IssueReported

  describe "report issue" do
    test "should emit IssueReported event when valid data is provided" do
      issue = %Issue{}

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

      assert {:ok, [^expected_event]} = Issue.execute(issue, cmd)
    end
  end
end
