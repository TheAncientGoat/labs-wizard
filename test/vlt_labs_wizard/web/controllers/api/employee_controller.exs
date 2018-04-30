defmodule VltLabsWizard.Web.EmployeeControllerTest do
  use VltLabsWizard.Web.ConnCase

  alias VltLabsWizard.HR
  alias VltLabsWizard.HR.Employee

  @create_attrs %{avatar: "some avatar", email: "some email", first_name: "some first_name", last_name: "some last_name", mobile: "some mobile", nickname: "some nickname", title: "some title"}
  @update_attrs %{avatar: "some updated avatar", email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", mobile: "some updated mobile", nickname: "some updated nickname", title: "some updated title"}
  @invalid_attrs %{avatar: nil, email: nil, first_name: nil, last_name: nil, mobile: nil, nickname: nil, title: nil}

  def fixture(:employee) do
    {:ok, employee} = HR.create_employee(@create_attrs)
    employee
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_employee_api_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "lists all entries on index when index not empty", %{conn: conn} do
    x = insert(:employee)
    conn = get conn, api_employee_api_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 1
  end
  
  test "creates employee and renders employee when data is valid", %{conn: conn} do
    department = insert(:department)
    final_create_attrs = Enum.into(@create_attrs,
      %{department_id: department.id}
    )
    conn = post conn, api_employee_api_path(conn, :create),
      employee:  final_create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, api_employee_api_path(conn, :show, id)
    assert json_response(conn, 200)["data"] ==
      Enum.into(
        Enum.map(@create_attrs,
          fn({key, val}) -> { Atom.to_string(key), val} end),
        %{"id" => id, "department" => department.name}
      )
  end

  test "does not create employee and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_employee_api_path(conn, :create), employee: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen employee and renders employee when data is valid", %{conn: conn} do
    %Employee{id: id} = employee = fixture(:employee)
    conn = put conn, api_employee_api_path(conn, :update, employee), employee: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, api_employee_api_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "employees" => [],
      "name" => "some updated name"}
  end

  test "does not update chosen employee and renders errors when data is invalid", %{conn: conn} do
    employee = fixture(:employee)
    conn = put conn, api_employee_api_path(conn, :update, employee), employee: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen employee", %{conn: conn} do
    employee = fixture(:employee)
    conn = delete conn, api_employee_api_path(conn, :delete, employee)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, api_employee_api_path(conn, :show, employee)
    end
  end
end
