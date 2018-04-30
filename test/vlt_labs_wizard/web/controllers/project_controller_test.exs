defmodule VltLabsWizard.Web.ProjectControllerTest do
  use VltLabsWizard.Web.ConnCase

  alias VltLabsWizard.Projects

  @create_attrs %{description: "some description", estimated_man_days: "120.5", manday_cost: "120.5", max_manday: 42, min_manday: 42, name: "some name", priority: 42, production_url: "some production_url", staging_url: "some staging_url", status: 2}
  @update_attrs %{description: "some updated description", estimated_man_days: "456.7", manday_cost: "456.7", max_manday: 43, min_manday: 43, name: "some updated name", priority: 43, production_url: "some updated production_url", staging_url: "some updated staging_url", status: 0}
  @invalid_attrs %{description: nil, estimated_man_days: nil, manday_cost: nil, max_manday: nil, min_manday: nil, name: nil, priority: nil, production_url: nil, staging_url: nil, status: nil}

  def fixture(:project) do
    {:ok, project} = Projects.create_project(@create_attrs)
    project
  end

  setup do
    user = insert(:user)
    {:ok, [conn: login(user)]}
  end
  # We need a way to get into the connection to login a user
  # We need to use the bypass_through to fire the plugs in the router
  # and get the session fetched.
  def guardian_login(user, token \\ :token, opts \\ []) do
    conn = build_conn
    conn
    #|> bypass_through(VltLabsWizard.Router, [:browser, :browser_authenticated_session])
    |> get(session_path(conn, :new))
    |> Map.update!(:state, fn (_) -> :set end)
    |> Guardian.Plug.sign_in(user, token, opts)
    |> send_resp(200, "Flush the session")
    |> recycle()
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, project_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Projects"
  end

  test "renders form for new projects", %{conn: conn} do
    conn = get conn, project_path(conn, :new)
    assert html_response(conn, 200) =~ "New Project"
  end

  test "creates project and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == project_path(conn, :show, id)

    conn = get conn, project_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Project"
  end

  test "does not create project and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @invalid_attrs
    assert html_response(conn, 200) =~ "New Project"
  end

  test "renders form for editing chosen project", %{conn: conn} do
    project = fixture(:project)
    conn = get conn, project_path(conn, :edit, project)
    assert html_response(conn, 200) =~ "Edit Project"
  end

  test "updates chosen project and redirects when data is valid", %{conn: conn} do
    project = fixture(:project)
    conn = put conn, project_path(conn, :update, project), project: @update_attrs
    assert redirected_to(conn) == project_path(conn, :show, project)

    conn = get conn, project_path(conn, :show, project)
    assert html_response(conn, 200) =~ "some updated description"
  end

  test "does not update chosen project and renders errors when data is invalid", %{conn: conn} do
    project = fixture(:project)
    conn = put conn, project_path(conn, :update, project), project: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Project"
  end

  test "deletes chosen project", %{conn: conn} do
    project = fixture(:project)
    conn = delete conn, project_path(conn, :delete, project)
    assert redirected_to(conn) == project_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, project_path(conn, :show, project)
    end
  end
end
