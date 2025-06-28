defmodule CivicFlux.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CivicFluxWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:civic_flux, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CivicFlux.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CivicFlux.Finch},
      # Start a worker by calling: CivicFlux.Worker.start_link(arg)
      # {CivicFlux.Worker, arg},
      # Start to serve requests, typically the last entry
      CivicFluxWeb.Endpoint,
      CivicFlux.App,
      CivicFlux.Repo,
      CivicFlux.Projectors.IssueProjector
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CivicFlux.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CivicFluxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
