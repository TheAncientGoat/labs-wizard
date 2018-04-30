defmodule VltLabsWizard.Web.EmployeeController do
  use VltLabsWizard.Web, :controller

  alias VltLabsWizard.HR

  def index(conn, _params) do
    employees = HR.list_employees()
    render(conn, "index.html", employees: employees)
  end

  def new(conn, _params) do
    changeset = HR.change_employee(%VltLabsWizard.HR.Employee{})
    departments = HR.selectable_departments
    render(conn, "new.html", changeset: changeset, departments: departments)
  end

  def create(conn, %{"employee" => employee_params}) do
    departments = HR.selectable_employees
    case HR.create_employee(employee_params) do
      {:ok, employee} ->
        conn
        |> put_flash(:info, "Employee created successfully.")
        |> redirect(to: employee_path(conn, :show, employee))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, departments: departments)
    end
  end

  def show(conn, %{"id" => id}) do
    employee = HR.get_employee!(id)
    render(conn, "show.html", employee: employee)
  end

  def edit(conn, %{"id" => id}) do
    employee = HR.get_employee!(id)
    departments = HR.selectable_employees
    changeset = HR.change_employee(employee)
    render(conn, "edit.html", employee: employee,
      changeset: changeset, departments: departments)
  end

  def update(conn, %{"id" => id, "employee" => employee_params}) do
    employee = HR.get_employee!(id)
    departments = HR.selectable_employees

    case HR.update_employee(employee, employee_params) do
      {:ok, employee} ->
        conn
        |> put_flash(:info, "Employee updated successfully.")
        |> redirect(to: employee_path(conn, :show, employee))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", employee: employee,
          changeset: changeset, departments: departments)
    end
  end

  def delete(conn, %{"id" => id}) do
    employee = HR.get_employee!(id)
    {:ok, _employee} = HR.delete_employee(employee)

    conn
    |> put_flash(:info, "Employee deleted successfully.")
    |> redirect(to: employee_path(conn, :index))
  end
end
