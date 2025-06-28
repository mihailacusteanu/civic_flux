defmodule CivicFlux.ReadModels.Issue do
  @moduledoc """
  Read model for an issue.
  """
  use Ecto.Schema

  @primary_key {:id, :string, autogenerate: false}
  schema "issues" do
    field(:description, :string)
    field(:location, :string)

    timestamps()
  end
end
