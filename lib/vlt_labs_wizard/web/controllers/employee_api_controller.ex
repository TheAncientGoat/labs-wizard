defmodule VltLabsWizard.Web.EmployeeApiController do
  @moduledoc "JSON REST api for employees"
  use VltLabsWizard.Web, :controller

  alias VltLabsWizard.HR
  alias VltLabsWizard.HR.Employee

  action_fallback VltLabsWizard.Web.FallbackController

  def index(conn, _params) do
    employees = HR.list_employees()
    render(conn, "index.json", employees: employees)
  end

  def create(conn, %{"employee" => employee_params}) do
    with {:ok, %Employee{} = employee} <- HR.create_employee(employee_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_employee_api_path(conn, :show, employee))
      |> render("show.json", employee: employee)
    end
  end

  def show(conn, %{"id" => id}) do
    employee = HR.get_employee!(id)
    render(conn, "show.json", employee: employee)
  end

  def update(conn, %{"id" => id, "employee" => employee_params}) do
    employee = HR.get_employee!(id)

    with {:ok, %Employee{} = employee} <- HR.update_employee(employee, employee_params) do
      render(conn, "show.json", employee: employee)
    end
  end

  def delete(conn, %{"id" => id}) do
    employee = HR.get_employee!(id)
    with {:ok, %Employee{}} <- HR.delete_employee(employee) do
      send_resp(conn, :no_content, "")
    end
  end
end
