defmodule VltLabsWizard.Bot.SlackMessage do
  use Ecto.Schema

  import Ecto.Changeset

  alias VltLabsWizard.Bot.SlackMessage

  schema "bot_slack_message" do
    field :message, :string
  end
end
