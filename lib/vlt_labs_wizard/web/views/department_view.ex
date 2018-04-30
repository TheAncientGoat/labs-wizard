defmodule VltLabsWizard.Web.DepartmentView do
  use VltLabsWizard.Web, :view
  alias VltLabsWizard.Web.DepartmentView

  def render("index.json", %{departments: departments}) do
    %{data: render_many(departments, DepartmentView, "department.json")}
  end

  def render("show.json", %{department: department}) do
    %{data: render_one(department, DepartmentView, "department.json")}
  end

  def render("department.json", %{department: department}) do
    %{id: department.id,
      name: department.name,
      employees: department.employees
    }
  end
end
