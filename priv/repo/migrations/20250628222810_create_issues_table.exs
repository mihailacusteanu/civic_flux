defmodule CivicFlux.Repo.Migrations.CreateIssuesTable do
  use Ecto.Migration

  def change do
    create table(:issues, primary_key: false) do
      add :id, :string, primary_key: true
      add :description, :string
      add :location, :string

      timestamps()
    end
  end
end
