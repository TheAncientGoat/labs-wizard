defmodule VltLabsWizard.Web.API.AssignmentControllerTest do
  use VltLabsWizard.Web.ConnCase

  alias VltLabsWizard.Projects
  alias VltLabsWizard.Projects.Assignment

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:assignment) do
    {:ok, assignment} = Projects.create_assignment(@create_attrs)
    assignment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, assignment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates assignment and renders assignment when data is valid", %{conn: conn} do
    conn = post conn, assignment_path(conn, :create), assignment: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, assignment_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id}
  end

  test "does not create assignment and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, assignment_path(conn, :create), assignment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen assignment and renders assignment when data is valid", %{conn: conn} do
    %Assignment{id: id} = assignment = fixture(:assignment)
    conn = put conn, assignment_path(conn, :update, assignment), assignment: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, assignment_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id}
  end

  test "does not update chosen assignment and renders errors when data is invalid", %{conn: conn} do
    assignment = fixture(:assignment)
    conn = put conn, assignment_path(conn, :update, assignment), assignment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen assignment", %{conn: conn} do
    assignment = fixture(:assignment)
    conn = delete conn, assignment_path(conn, :delete, assignment)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, assignment_path(conn, :show, assignment)
    end
  end
end
