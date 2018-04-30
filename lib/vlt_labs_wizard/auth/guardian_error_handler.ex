defmodule VltLabsWizard.Auth.GaurdianErrorHandler do
  @moduledoc "Simple unauthenticated handler"
  import VltLabsWizard.Web.Router.Helpers
  def unauthenticated(conn, _params) do
    conn
    |> Phoenix.Controller.put_flash(:error,
      "You must be signed in to view this page"
    )
    |> Phoenix.Controller.redirect(to: session_path(conn, :new))
  end
end
