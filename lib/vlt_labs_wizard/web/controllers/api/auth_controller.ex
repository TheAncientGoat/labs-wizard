defmodule VltLabsWizard.Web.API.AuthController do
  use VltLabsWizard.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  plug :scrub_params, "session" when action in ~w(create)a
  alias VltLabsWizard.Auth

  action_fallback VltLabsWizard.Web.FallbackController

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
      {:ok, {conn, token}} ->
        conn
        |> render("show.json", token: token, employee_id: user.employee_id)
      {:error, _reason, conn} ->
        conn
        |> render("error.json")
    end

  end

  def delete(conn, _) do
    conn
    |> logout
    |> render("logout.json")
  end

  defp logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

  defp login(conn, user) do
    {:ok, token, _} =
      Guardian.encode_and_sign(user, :access)
    {conn, token}
  end
end
