defmodule VltLabsWizard.Web.API.ProjectView do
  use VltLabsWizard.Web, :view
  alias VltLabsWizard.Web.API.ProjectView

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    project
  end
end
