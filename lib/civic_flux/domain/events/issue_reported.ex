defmodule CivicFlux.Domain.Events.IssueReported do
  @moduledoc """
  Eveniment emis când un cetățean raportează o problemă.
  """

  @derive Jason.Encoder
  defstruct [
    :id,
    :description,
    :location
  ]
end
