defmodule VltLabsWizard.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(VltLabsWizard.Repo, []),
      # Start the endpoint when the application starts
      supervisor(VltLabsWizard.Web.Endpoint, []),
    ]
    with_bot = children ++ [
      worker(Slack.Bot,
        [VltLabsWizard.Bot.SlackRtm, [],
         Application.get_env(:slack, :api_token),
         %{name: :slack}]),
      worker(VltLabsWizard.Bot.SlackScheduler, [])
    ]

    Application.get_all_env
    final_children = if Application.get_env(:slack, :enabled) do
      with_bot
    else
      children
    end
    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VltLabsWizard.Supervisor]

    Supervisor.start_link(final_children, opts)
  end
end
