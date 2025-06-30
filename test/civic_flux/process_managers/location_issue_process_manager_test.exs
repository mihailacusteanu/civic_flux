defmodule CivicFlux.ProcessManagers.LocationIssueProcessManagerTest do
  use ExUnit.Case, async: false

  import Commanded.Assertions.EventAssertions

  alias CivicFlux.App
  alias CivicFlux.Domain.Commands.ReportIssue
  alias CivicFlux.Domain.Events.LocationAddedToMap
  alias CivicFlux.Domain.Events.LocationMarkedForAttention

  def unique_issue_id, do: "ISSUE-#{System.unique_integer([:positive])}"

  setup do
    CivicFlux.Repo.delete_all("projection_versions")
    :ok
  end

  describe "location issue process manager" do
    test "handles first issue at a location" do
      location = "București, Sector 1, Str Test #{System.unique_integer([:positive])}"
      id = unique_issue_id()

      cmd = %ReportIssue{
        id: id,
        description: "Test issue for process manager",
        location: location
      }

      assert :ok = App.dispatch(cmd)

      wait_for_event(App, LocationAddedToMap, fn event ->
        event.location == location
      end)
    end

    test "tracks multiple issues at a location" do
      location = "București, Sector 2, Str Priority #{System.unique_integer([:positive])}"

      cmd = %ReportIssue{
        id: unique_issue_id(),
        description: "Initial issue at location",
        location: location
      }

      assert :ok = App.dispatch(cmd)

      wait_for_event(App, LocationAddedToMap, fn event ->
        event.location == location
      end)

      Enum.each(1..10, fn i ->
        cmd = %ReportIssue{
          id: unique_issue_id(),
          description: "Test issue #{i} for threshold testing",
          location: location
        }

        assert :ok = App.dispatch(cmd)
      end)

      wait_for_event(App, LocationMarkedForAttention, fn event ->
        event.location == location
      end)
    end
  end
end
