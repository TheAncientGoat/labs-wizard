defmodule VltLabsWizard.Web.ManDayPurchaseControllerTest do
  use VltLabsWizard.Web.ConnCase

  alias VltLabsWizard.Finance
  alias VltLabsWizard.Finance.ManDayPurchase

  @create_attrs %{days_purchased: "120.5", purchased_on: ~D[2010-04-17], total_cost: "120.5"}
  @update_attrs %{days_purchased: "456.7", purchased_on: ~D[2011-05-18], total_cost: "456.7"}
  @invalid_attrs %{days_purchased: nil, purchased_on: nil, total_cost: nil}

  def create_attrs do
    @create_attrs
    |> Map.merge(%{project_id: insert(:project).id})
  end

  def fixture(:man_day_purchase) do
    {:ok, man_day_purchase} = Finance.create_man_day_purchase(create_attrs)
    man_day_purchase
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_man_day_purchase_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates man_day_purchase and renders man_day_purchase when data is valid", %{conn: conn} do
    conn = post conn, api_man_day_purchase_path(conn, :create), man_day_purchase: create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, api_man_day_purchase_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "days_purchased" => "120.5",
      "purchased_on" => "2010-04-17",
      "total_cost" => "120.5"}
  end

  test "does not create man_day_purchase and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_man_day_purchase_path(conn, :create), man_day_purchase: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen man_day_purchase and renders man_day_purchase when data is valid", %{conn: conn} do
    %ManDayPurchase{id: id} = man_day_purchase = fixture(:man_day_purchase)
    conn = put conn, api_man_day_purchase_path(conn, :update, man_day_purchase), man_day_purchase: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, api_man_day_purchase_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "days_purchased" => "456.7",
      "purchased_on" => "2011-05-18",
      "total_cost" => "456.7"}
  end

  test "does not update chosen man_day_purchase and renders errors when data is invalid", %{conn: conn} do
    man_day_purchase = fixture(:man_day_purchase)
    conn = put conn, api_man_day_purchase_path(conn, :update, man_day_purchase), man_day_purchase: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen man_day_purchase", %{conn: conn} do
    man_day_purchase = fixture(:man_day_purchase)
    conn = delete conn, api_man_day_purchase_path(conn, :delete, man_day_purchase)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, api_man_day_purchase_path(conn, :show, man_day_purchase)
    end
  end
end
