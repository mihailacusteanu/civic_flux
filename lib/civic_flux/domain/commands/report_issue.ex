defmodule CivicFlux.Domain.Commands.ReportIssue do
  @moduledoc """
  Comanda pentru raportarea unei probleme de infrastructură.
  """

  defstruct [
    :id,
    :description,
    :location
  ]
end
