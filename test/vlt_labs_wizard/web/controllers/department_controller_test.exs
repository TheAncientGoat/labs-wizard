defmodule VltLabsWizard.Web.DepartmentControllerTest do
  use VltLabsWizard.Web.ConnCase

  alias VltLabsWizard.HR
  alias VltLabsWizard.HR.Department

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:department) do
    {:ok, department} = HR.create_department(@create_attrs)
    department
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_department_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates department and renders department when data is valid", %{conn: conn} do
    conn = post conn, api_department_path(conn, :create), department: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, api_department_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "employees" => [],
      "name" => "some name"}
  end

  test "does not create department and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_department_path(conn, :create), department: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen department and renders department when data is valid", %{conn: conn} do
    %Department{id: id} = department = fixture(:department)
    conn = put conn, api_department_path(conn, :update, department), department: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, api_department_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "employees" => [],
      "name" => "some updated name"}
  end

  test "does not update chosen department and renders errors when data is invalid", %{conn: conn} do
    department = fixture(:department)
    conn = put conn, api_department_path(conn, :update, department), department: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen department", %{conn: conn} do
    department = fixture(:department)
    conn = delete conn, api_department_path(conn, :delete, department)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, api_department_path(conn, :show, department)
    end
  end
end
