defmodule WmTweeter.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    wm_config = Application.get_env(:wm_tweeter, :web_config)
    # Define workers and child supervisors to be supervised
    children = [
      worker(:webmachine_mochiweb, [wm_config], function: :start, modules: [:mochiweb_socket_server])
      # Starts a worker by calling: WmTweeter.Worker.start_link(arg1, arg2, arg3)
      # worker(WmTweeter.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WmTweeter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
