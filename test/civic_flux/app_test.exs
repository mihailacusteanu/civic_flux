defmodule CivicFlux.AppTest do
  use ExUnit.Case, async: false

  import Commanded.Assertions.EventAssertions

  alias CivicFlux.App
  alias CivicFlux.Domain.Commands.ReportIssue
  alias CivicFlux.Domain.Events.IssueReported

  def unique_issue_id, do: "ISSUE-#{System.unique_integer([:positive])}"

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CivicFlux.Repo)
    :ok
  end

  describe "ReportIssue command" do
    test "dispatches successfully" do
      id = "ISSUE-#{System.unique_integer([:positive])}"

      cmd = %ReportIssue{
        id: id,
        description: "Test issue for app test",
        location: "Strada Testului 42"
      }

      assert :ok = App.dispatch(cmd)
    end

    test "dispatches correct command" do
      id = unique_issue_id()
      description = "Test issue"
      location = "Test location"

      cmd = %ReportIssue{
        id: id,
        description: description,
        location: location
      }

      assert :ok = App.dispatch(cmd)
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
