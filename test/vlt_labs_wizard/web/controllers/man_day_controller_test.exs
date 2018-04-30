defmodule VltLabsWizard.Web.ManDayControllerTest do
  use VltLabsWizard.Web.ConnCase

  alias VltLabsWizard.Projects

  @create_attrs %{title: "some title", days: "120.5", notes: "some notes", performed_on: ~D[2010-04-17]}
  @update_attrs %{days: "456.7", notes: "some updated notes", performed_on: ~D[2011-05-18]}
  @invalid_attrs %{days: nil, notes: nil, performed_on: nil}

  setup do
    user = insert(:user)
    {:ok, [conn: login(user), project_id: insert(:project).id, employee_id: insert(:employee).id]}
  end

  def fixture(:man_day, pid, eid) do
    {:ok, man_day} = Projects.create_man_day(create_attrs(pid, eid))
    man_day
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, man_day_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Man days"
  end

  test "renders form for new man_days", %{conn: conn} do
    conn = get conn, man_day_path(conn, :new)
    assert html_response(conn, 200) =~ "New Man day"
  end

  def create_attrs(pid, eid) do
    Map.merge(@create_attrs, %{project_id: pid, employee_id: eid})
  end

  test "creates man_day and redirects to show when data is valid",
    %{conn: conn, project_id: pid, employee_id: eid} do
    conn = post conn, man_day_path(conn, :create), man_day: create_attrs(pid, eid)

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == man_day_path(conn, :show, id)

    conn = get conn, man_day_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Man day"
  end

  test "does not create man_day and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, man_day_path(conn, :create), man_day: @invalid_attrs
    assert html_response(conn, 200) =~ "New Man day"
  end

  test "renders form for editing chosen man_day",
    %{conn: conn, project_id: pid, employee_id: eid} do
    man_day = fixture(:man_day, pid, eid)
    conn = get conn, man_day_path(conn, :edit, man_day)
    assert html_response(conn, 200) =~ "Edit Man day"
  end

  test "updates chosen man_day and redirects when data is valid",
    %{conn: conn, project_id: pid, employee_id: eid} do
    man_day = fixture(:man_day, pid, eid)
    conn = put conn, man_day_path(conn, :update, man_day), man_day: @update_attrs
    assert redirected_to(conn) == man_day_path(conn, :show, man_day)

    conn = get conn, man_day_path(conn, :show, man_day)
    assert html_response(conn, 200) =~ "some updated notes"
  end

  test "does not update chosen man_day and renders errors when data is invalid",
    %{conn: conn, project_id: pid, employee_id: eid} do
    man_day = fixture(:man_day, pid, eid)
    conn = put conn, man_day_path(conn, :update, man_day), man_day: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Man day"
  end

  test "deletes chosen man_day",
      %{conn: conn, project_id: pid, employee_id: eid} do
    man_day = fixture(:man_day, pid, eid)
    conn = delete conn, man_day_path(conn, :delete, man_day)
    assert redirected_to(conn) == man_day_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, man_day_path(conn, :show, man_day)
    end
  end
end
