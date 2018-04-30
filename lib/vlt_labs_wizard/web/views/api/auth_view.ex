defmodule VltLabsWizard.Web.API.AuthView do
  use VltLabsWizard.Web, :view
  alias VltLabsWizard.Web.API.AuthView

  def render("show.json", %{token: token, employee_id: employee_id}) do
    %{token: token, employee_id: employee_id}
  end

  def render("error.json", _) do
    %{error: "Could not sign in"}
  end

  def render("unauthenticated.json", _) do
    %{error: "Please sign in"}
  end

  def render("logout.json", _) do
    %{error: "Logged out"}
  end

  def render("assignment.json", %{assignment: assignment}) do
    assignment
  end
end
