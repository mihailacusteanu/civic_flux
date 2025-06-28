defmodule CivicFlux.Test.AssertionHelpers do
  @moduledoc """
  Helper functions for common test assertions, particularly
  for CQRS/EventSourcing related testing.
  """

  # Not using ExUnit.Assertions here, but might need it for future helper functions

  @doc """
  Helper for testing eventual consistency in projections.

  Repeatedly calls the given function until it returns a truthy value or exceeds the number of attempts.

  ## Parameters
    * `fun` - The function to call that should return truthy when the condition is met
    * `attempts` - Number of attempts to try (default: 2)
    * `sleep_ms` - Milliseconds to wait between attempts (default: 50)

  ## Examples
      # Verify a read model was updated
      assert eventually(fn -> 
        issue = Repo.get(Issue, id) 
        issue != nil && issue.title == "New Title"
      end)
      
  ## Returns
    * `true` - If the function returned a truthy value within the attempts
    * `false` - If the function never returned a truthy value
  """
  def eventually(fun, attempts \\ 2, sleep_ms \\ 50)
  def eventually(_fun, 0, _sleep_ms), do: false

  def eventually(fun, attempts, sleep_ms) do
    case fun.() do
      result when result in [nil, false] ->
        Process.sleep(sleep_ms)
        eventually(fun, attempts - 1, sleep_ms)

      _ ->
        true
    end
  end
end
