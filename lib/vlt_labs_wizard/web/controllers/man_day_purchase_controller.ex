defmodule VltLabsWizard.Web.ManDayPurchaseController do
  use VltLabsWizard.Web, :controller

  alias VltLabsWizard.Finance
  alias VltLabsWizard.Finance.ManDayPurchase

  action_fallback VltLabsWizard.Web.FallbackController

  def index(conn, _params) do
    man_day_purchase = Finance.list_man_day_purchase()
    render(conn, "index.json", man_day_purchase: man_day_purchase)
  end

  def create(conn, %{"man_day_purchase" => man_day_purchase_params}) do
    with {:ok, %ManDayPurchase{} = man_day_purchase} <- Finance.create_man_day_purchase(man_day_purchase_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_man_day_purchase_path(conn, :show, man_day_purchase))
      |> render("show.json", man_day_purchase: man_day_purchase)
    end
  end

  def show(conn, %{"id" => id}) do
    man_day_purchase = Finance.get_man_day_purchase!(id)
    render(conn, "show.json", man_day_purchase: man_day_purchase)
  end

  def update(conn, %{"id" => id, "man_day_purchase" => man_day_purchase_params}) do
    man_day_purchase = Finance.get_man_day_purchase!(id)

    with {:ok, %ManDayPurchase{} = man_day_purchase} <- Finance.update_man_day_purchase(man_day_purchase, man_day_purchase_params) do
      render(conn, "show.json", man_day_purchase: man_day_purchase)
    end
  end

  def delete(conn, %{"id" => id}) do
    man_day_purchase = Finance.get_man_day_purchase!(id)
    with {:ok, %ManDayPurchase{}} <- Finance.delete_man_day_purchase(man_day_purchase) do
      send_resp(conn, :no_content, "")
    end
  end
end
