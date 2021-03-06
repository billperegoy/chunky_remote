defmodule ChunkyRemote.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Setup event_bus topics
    EventBus.register_topic(:user_created)
    EventBus.subscribe({ChunkyRemote.Notifier, ["user_created"]})

    children = [
      # Start the Ecto repository
      ChunkyRemote.Repo,
      # Start the Telemetry supervisor
      ChunkyRemoteWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ChunkyRemote.PubSub},
      # Start the Endpoint (http/https)
      ChunkyRemoteWeb.Endpoint
      # Start a worker by calling: ChunkyRemote.Worker.start_link(arg)
      # {ChunkyRemote.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChunkyRemote.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ChunkyRemoteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
