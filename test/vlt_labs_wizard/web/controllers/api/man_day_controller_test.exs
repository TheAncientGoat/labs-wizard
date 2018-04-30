defmodule VltLabsWizard.Web.API.ManDayControllerTest do
  use VltLabsWizard.Web.ConnCase

  alias VltLabsWizard.Projects
  alias VltLabsWizard.Projects.ManDay

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:man_day) do
    {:ok, man_day} = Projects.create_man_day(@create_attrs)
    man_day
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_man_day_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates man_day and renders man_day when data is valid", %{conn: conn} do
    conn = post conn, api_man_day_path(conn, :create), man_day: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, api_man_day_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id}
  end

  test "does not create man_day and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_man_day_path(conn, :create), man_day: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen man_day and renders man_day when data is valid", %{conn: conn} do
    %ManDay{id: id} = man_day = fixture(:man_day)
    conn = put conn, api_man_day_path(conn, :update, man_day), man_day: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, api_man_day_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id}
  end

  test "does not update chosen man_day and renders errors when data is invalid", %{conn: conn} do
    man_day = fixture(:man_day)
    conn = put conn, api_man_day_path(conn, :update, man_day), man_day: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen man_day", %{conn: conn} do
    man_day = fixture(:man_day)
    conn = delete conn, api_man_day_path(conn, :delete, man_day)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, api_man_day_path(conn, :show, man_day)
    end
  end
end
