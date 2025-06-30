defmodule CivicFlux.AppTest do
  use ExUnit.Case, async: false

  import Commanded.Assertions.EventAssertions

  alias CivicFlux.App
  alias CivicFlux.Domain.Commands.ReportIssue
  alias CivicFlux.Domain.Events.LocationAddedToMap
  alias CivicFlux.Domain.Events.LocationMarkedForAttention

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

  describe "dispatch multiple ReportIssue commands" do
    test "when number of dispatched commands is less than 10 and that only LocationAddedToMap events are emitted" do
      Enum.each(1..9, fn i ->
        cmd = %ReportIssue{
          id: unique_issue_id(),
          description: "Test issue #{i}",
          location: "Test location #{i}"
        }

        assert :ok = App.dispatch(cmd)
      end)

      for i <- 1..9 do
        wait_for_event(App, LocationAddedToMap, fn event ->
          event.location == "Test location #{i}"
        end)
      end
    end

    test "when number of dispatched commands is 10 and that LocationMarkedForAttention event is emitted" do
      location = "Same location #{System.unique_integer([:positive])}"

      Enum.each(1..10, fn i ->
        cmd = %ReportIssue{
          id: unique_issue_id(),
          description: "Test issue #{i}",
          location: location
        }

        assert :ok = App.dispatch(cmd)
        Process.sleep(10)
      end)

      for _ <- 1..9 do
        wait_for_event(App, LocationAddedToMap, fn event ->
          event.location == location
        end)
      end

      wait_for_event(App, LocationMarkedForAttention, fn event ->
        event.location == location
      end)
    end
  end
end
