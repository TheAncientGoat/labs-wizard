defmodule VltLabsWizard.Web.API.ProjectControllerTest do
  use VltLabsWizard.Web.ConnCase

  alias VltLabsWizard.Projects
  alias VltLabsWizard.Projects.Project

  @create_attrs %{description: "some description", estimated_man_days: "120.5", manday_cost: "120.5", max_manday: 42, min_manday: 42, name: "some name", priority: 42, production_url: "some production_url", staging_url: "some staging_url", status: 2}
  @update_attrs %{description: "update description"}
  @invalid_attrs %{}

  def fixture(:project) do
    {:ok, project} = Projects.create_project(@create_attrs)
    project
  end

  setup %{conn: conn} do
    user = insert(:user)
    {:ok, token, _} = Guardian.encode_and_sign(user, :access)
    conn = conn
    |> put_req_header("authorization", token)
    |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_project_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "lists all entries on index when index not empty", %{conn: conn} do
    x = insert(:project)
    conn = get conn, api_project_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 1
  end

  test "creates project and renders project when data is valid", %{conn: conn} do
    conn = put_req_header(conn, "content-type", "application/json")
    r_conn = post conn, api_project_path(conn, :create), project: @create_attrs
    assert %{"id" => id, "total_man_days_purchased" => tmdp} = json_response(r_conn, 201)["data"]

    conn = get conn, api_project_path(conn, :show, id)
    assert %{"id" => id} = json_response(conn, 200)["data"]
  end

  test "does not create project and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_project_path(conn, :create), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen project and renders project when data is valid", %{conn: conn} do
    %Project{id: id} = project = fixture(:project)
    u_conn = put conn, api_project_path(conn, :update, project), project: @update_attrs
    assert %{"id" => ^id} = json_response(u_conn, 200)["data"]

    conn = get conn, api_project_path(conn, :show, id)
    assert %{"id" => ^id, "description" => "update description" } = json_response(conn, 200)["data"]
  end

  test "does not update chosen project and renders errors when data is invalid", %{conn: conn} do
    project = fixture(:project)
    conn = put conn, api_project_path(conn, :update, project), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen project", %{conn: conn} do
    project = fixture(:project)
    conn = delete conn, api_project_path(conn, :delete, project)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, api_project_path(conn, :show, project)
    end
  end
end
