defmodule VltLabsWizard.Web.ManDayPurchaseView do
  use VltLabsWizard.Web, :view
  alias VltLabsWizard.Web.ManDayPurchaseView

  def render("index.json", %{man_day_purchase: man_day_purchase}) do
    %{data: render_many(man_day_purchase, ManDayPurchaseView, "man_day_purchase.json")}
  end

  def render("show.json", %{man_day_purchase: man_day_purchase}) do
    %{data: render_one(man_day_purchase, ManDayPurchaseView, "man_day_purchase.json")}
  end

  def render("man_day_purchase.json", %{man_day_purchase: man_day_purchase}) do
    %{id: man_day_purchase.id,
      purchased_on: man_day_purchase.purchased_on,
      days_purchased: man_day_purchase.days_purchased,
      total_cost: man_day_purchase.total_cost}
  end
end
