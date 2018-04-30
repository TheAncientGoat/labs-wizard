defmodule VltLabsWizard.Web.API.ManDayView do
  use VltLabsWizard.Web, :view
  alias VltLabsWizard.Web.API.ManDayView

  def render("index.json", %{man_days: man_days}) do
    %{data: render_many(man_days, ManDayView, "man_day.json")}
  end

  def render("show.json", %{man_day: man_day}) do
    %{data: render_one(man_day, ManDayView, "man_day.json")}
  end

  def render("man_day.json", %{man_day: man_day}) do
    man_day
  end
end
