defmodule VltLabsWizard.Web.AssignmentControllerTest do
  use VltLabsWizard.Web.ConnCase

  alias VltLabsWizard.Projects

  @create_attrs %{estimated_days: 42, estimated_end: ~D[2010-04-17],
                  employee: Map.from_struct(build(:employee)),
                  project: Map.from_struct(build(:project)),
                  estimated_start: ~D[2010-04-17]}

  @update_attrs %{estimated_days: 43, estimated_end: ~D[2011-05-18], estimated_start: ~D[2011-05-18]}
  @invalid_attrs %{estimated_days: nil, estimated_end: nil, estimated_start: nil}

  def fixture(:assignment) do
    {:ok, assignment} = Projects.create_assignment(@create_attrs)
    assignment
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, assignment_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Assignments"
  end

  test "renders form for new assignments", %{conn: conn} do
    conn = get conn, assignment_path(conn, :new)
    assert html_response(conn, 200) =~ "New Assignment"
  end

  test "creates assignment and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, assignment_path(conn, :create), assignment: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == assignment_path(conn, :show, id)

    conn = get conn, assignment_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Assignment"
  end

  test "does not create assignment and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, assignment_path(conn, :create), assignment: @invalid_attrs
    assert html_response(conn, 200) =~ "New Assignment"
  end

  test "renders form for editing chosen assignment", %{conn: conn} do
    assignment = fixture(:assignment)
    conn = get conn, assignment_path(conn, :edit, assignment)
    assert html_response(conn, 200) =~ "Edit Assignment"
  end

  test "updates chosen assignment and redirects when data is valid", %{conn: conn} do
    assignment = fixture(:assignment)
    conn = put conn, assignment_path(conn, :update, assignment), assignment: @update_attrs
    assert redirected_to(conn) == assignment_path(conn, :show, assignment)

    conn = get conn, assignment_path(conn, :show, assignment)
    assert html_response(conn, 200)
  end

  test "does not update chosen assignment and renders errors when data is invalid", %{conn: conn} do
    assignment = fixture(:assignment)
    conn = put conn, assignment_path(conn, :update, assignment), assignment: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Assignment"
  end

  test "deletes chosen assignment", %{conn: conn} do
    assignment = fixture(:assignment)
    conn = delete conn, assignment_path(conn, :delete, assignment)
    assert redirected_to(conn) == assignment_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, assignment_path(conn, :show, assignment)
    end
  end
end
