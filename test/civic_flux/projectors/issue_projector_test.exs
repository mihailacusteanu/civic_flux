defmodule CivicFlux.Projectors.IssueProjectorTest do
  use ExUnit.Case, async: false

  import CivicFlux.Test.AssertionHelpers, only: [eventually: 1]

  alias CivicFlux.App
  alias CivicFlux.Domain.Commands.ReportIssue
  alias CivicFlux.ReadModels.Issue
  alias CivicFlux.Repo

  def unique_issue_id, do: "ISSUE-#{System.unique_integer([:positive])}"

  setup do
    Repo.delete_all(Issue)
    Repo.delete_all("projection_versions")
    :ok
  end

  describe "Issue Projector" do
    test "projects an issue to the database after reporting" do
      id = unique_issue_id()
      description = "Test proiecție"
      location = "Strada Testului"

      cmd = %ReportIssue{
        id: id,
        description: description,
        location: location
      }

      assert :ok = App.dispatch(cmd)

      assert eventually(fn ->
               issue = Repo.get(Issue, id)

               issue != nil &&
                 issue.description == description &&
                 issue.location == location
             end),
             "Expected issue to be projected in the database"
    end

    test "updates the projection when an issue is updated" do
      id = unique_issue_id()

      cmd = %ReportIssue{
        id: id,
        description: "Initial description",
        location: "Initial location"
      }

      assert :ok = App.dispatch(cmd)

      assert eventually(fn -> Repo.get(Issue, id) != nil end)

      issue = Repo.get(Issue, id)
      assert issue.description == "Initial description"
      assert issue.location == "Initial location"
    end
  end
end
