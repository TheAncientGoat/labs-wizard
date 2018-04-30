defmodule VltLabsWizard.Web.API.AssignmentView do
  use VltLabsWizard.Web, :view
  alias VltLabsWizard.Web.API.AssignmentView

  def render("index.json", %{assignments: assignments}) do
    %{data: render_many(assignments, AssignmentView, "assignment.json")}
  end

  def render("show.json", %{assignment: assignment}) do
    %{data: render_one(assignment, AssignmentView, "assignment.json")}
  end

  def render("assignment.json", %{assignment: assignment}) do
    assignment
  end
end
