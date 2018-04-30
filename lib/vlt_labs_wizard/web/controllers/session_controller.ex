defmodule VltLabsWizard.Web.SessionController do
  @moduledoc "Handles sign-in / sign-out requests"
  use VltLabsWizard.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  plug :scrub_params, "session" when action in ~w(create)a

  alias VltLabsWizard.Auth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{
                      "email" => email, "password" => password}}) do
    user = Auth.get_user_by(email: email)
    result = cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end

    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You're now logged in")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end

  end

  def delete(conn, _) do
    conn
    |> logout
    |> put_flash(:info, "Bye...")
    |> redirect(to: page_path(conn, :index))
  end

  defp logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

  defp login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end
end
