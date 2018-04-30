defmodule VltLabsWizard.Web.SlackView do
  use VltLabsWizard.Web, :view
  alias VltLabsWizard.Web.SlackView

  def render("index.json", %{slack: slack}) do
    %{data: render_many(slack, SlackView, "slack.json")}
  end

  def render("show.json", %{slack: slack}) do
    %{data: render_one(slack, SlackView, "slack.json")}
  end

  def render("slack.json", %{slack: slack}) do
    %{id: slack.id}
  end
end
