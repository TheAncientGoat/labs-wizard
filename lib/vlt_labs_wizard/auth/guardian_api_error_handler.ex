defmodule VltLabsWizard.Auth.GuardianApiErrorHandler do
  @moduledoc "Simple unauthenticated handler"

  def unauthenticated(conn, _params) do
    # Hacky, but allows for rendering auth errors on api routes
    conn
    |> Plug.Conn.put_status(401)
    |> Plug.Conn.put_private(:phoenix_action, :index)
    |> Phoenix.Controller.put_view(VltLabsWizard.Web.API.AuthView)
    |> Phoenix.Controller.render("unauthenticated.json")
  end
end
