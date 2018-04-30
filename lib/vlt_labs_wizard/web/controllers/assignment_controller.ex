defmodule VltLabsWizard.Web.AssignmentController do
  use VltLabsWizard.Web, :controller

  alias VltLabsWizard.Projects

  def index(conn, _params) do
    assignments = Projects.list_assignments()
    render(conn, "index.html", assignments: assignments)
  end

  def new(conn, _params) do
    changeset = Projects.change_assignment(%VltLabsWizard.Projects.Assignment{})
    employees = VltLabsWizard.HR.selectable_employees()
    projects = Projects.selectable_projects()
    conn
    |> assign(:changeset, changeset)
    |> assign(:employees, employees)
    |> assign(:projects, projects)
    |> render("new.html")
  end

  def create(conn, %{"assignment" => assignment_params}) do
    case Projects.create_assignment(assignment_params) do
      {:ok, assignment} ->
        conn
        |> put_flash(:info, "Assignment created successfully.")
        |> redirect(to: assignment_path(conn, :show, assignment))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset,
          employees: VltLabsWizard.HR.selectable_employees(),
          projects: Projects.selectable_projects()
        )
    end
  end

  def show(conn, %{"id" => id}) do
    assignment = Projects.get_assignment!(id)
    render(conn, "show.html", assignment: assignment)
  end

  def edit(conn, %{"id" => id}) do
    assignment = Projects.get_assignment!(id)
    changeset = Projects.change_assignment(assignment)
    render(conn, "edit.html", assignment: assignment,
      changeset: changeset,
      projects: Projects.selectable_projects(),
      employees: VltLabsWizard.HR.selectable_employees)
  end

  def update(conn, %{"id" => id, "assignment" => assignment_params}) do
    assignment = Projects.get_assignment!(id)

    case Projects.update_assignment(assignment, assignment_params) do
      {:ok, assignment} ->
        conn
        |> put_flash(:info, "Assignment updated successfully.")
        |> redirect(to: assignment_path(conn, :show, assignment))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", assignment: assignment, changeset: changeset,
          projects: Projects.selectable_projects(),
          employees: VltLabsWizard.HR.selectable_employees)
    end
  end

  def delete(conn, %{"id" => id}) do
    assignment = Projects.get_assignment!(id)
    {:ok, _assignment} = Projects.delete_assignment(assignment)

    conn
    |> put_flash(:info, "Assignment deleted successfully.")
    |> redirect(to: assignment_path(conn, :index))
  end
end
