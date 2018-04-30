defmodule VltLabsWizard.Web.PageController do
  use VltLabsWizard.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
