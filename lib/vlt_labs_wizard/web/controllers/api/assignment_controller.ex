defmodule VltLabsWizard.Web.API.AssignmentController do
  use VltLabsWizard.Web, :controller

  alias VltLabsWizard.Projects
  alias VltLabsWizard.Projects.Assignment

  action_fallback VltLabsWizard.Web.FallbackController

  def index(conn, _params) do
    assignments = Projects.list_assignments()
    render(conn, "index.json", assignments: assignments)
  end

  def create(conn, %{"assignment" => assignment_params}) do
    with {:ok, %Assignment{} = assignment} <- Projects.create_assignment(assignment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", assignment_path(conn, :show, assignment))
      |> render("show.json", assignment: assignment)
    end
  end

  def show(conn, %{"id" => id}) do
    assignment = Projects.get_assignment!(id)
    render(conn, "show.json", assignment: assignment)
  end

  def update(conn, %{"id" => id, "assignment" => assignment_params}) do
    assignment = Projects.get_assignment!(id)

    with {:ok, %Assignment{} = assignment} <- Projects.update_assignment(assignment, assignment_params) do
      render(conn, "show.json", assignment: assignment)
    end
  end

  def delete(conn, %{"id" => id}) do
    assignment = Projects.get_assignment!(id)
    with {:ok, %Assignment{}} <- Projects.delete_assignment(assignment) do
      send_resp(conn, :no_content, "")
    end
  end
end
