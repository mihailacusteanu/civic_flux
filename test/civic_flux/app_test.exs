defmodule CivicFlux.AppTest do
  use ExUnit.Case, async: false

  import Commanded.Assertions.EventAssertions

  alias CivicFlux.App
  alias CivicFlux.Domain.Commands.ReportIssue
  alias CivicFlux.Domain.Events.IssueReported

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CivicFlux.Repo)
    :ok
  end

  describe "ReportIssue command" do
    test "dispatches successfully" do
      id = "ISSUE-#{System.unique_integer([:positive])}"

      cmd = %ReportIssue{
        id: id,
        description: "Groapă mare",
        location: "Strada Testului 42"
      }

      assert :ok = App.dispatch(cmd)

      wait_for_event(App, IssueReported, fn event ->
        assert event.id == id
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
