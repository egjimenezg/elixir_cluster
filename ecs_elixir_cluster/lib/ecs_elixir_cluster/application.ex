defmodule EcsElixirCluster.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EcsElixirClusterWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:ecs_elixir_cluster, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EcsElixirCluster.PubSub},
      # Start a worker by calling: EcsElixirCluster.Worker.start_link(arg)
      # {EcsElixirCluster.Worker, arg},
      # Start to serve requests, typically the last entry
      EcsElixirClusterWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EcsElixirCluster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EcsElixirClusterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
