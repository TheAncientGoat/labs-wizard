require IEx

defmodule VltLabsWizard.Web.EmployeeApiView do
  use VltLabsWizard.Web, :view
  alias VltLabsWizard.Web.EmployeeApiView

  def render("index.json", %{employees: employees}) do
    %{data: render_many(employees, VltLabsWizard.Web.EmployeeApiView, "employee.json")}
  end

  def render("show.json", %{employee: employee}) do
    %{data: render_one(employee, EmployeeApiView, "employee.json")}
  end

  def render("employee.json", %{employee_api: x}) do
    x
  end
end
