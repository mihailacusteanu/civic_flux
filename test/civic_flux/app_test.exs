defmodule CivicFlux.AppTest do
  use ExUnit.Case, async: false

  import Commanded.Assertions.EventAssertions

  alias CivicFlux.App
  alias CivicFlux.Domain.Commands.ReportIssue
  alias CivicFlux.Domain.Events.IssueReported

  @issue_id "ISSUE-1"

  describe "ReportIssue command" do
    test "dispatches successfully" do
      cmd = %ReportIssue{
        id: @issue_id,
        description: "Groapă mare",
        location: "Strada Testului 42"
      }

      assert :ok = App.dispatch(cmd)

      wait_for_event(App, IssueReported, fn event ->
        assert event.id == @issue_id
        assert event.description == "Groapă mare"
        assert event.location == "Strada Testului 42"
      end)
    end

    test "fails when id is missing" do
      cmd = %ReportIssue{
        id: nil,
        description: "Fără ID",
        location: "Undeva"
      }

      assert {:error, _reason} = App.dispatch(cmd)
    end
  end
end
