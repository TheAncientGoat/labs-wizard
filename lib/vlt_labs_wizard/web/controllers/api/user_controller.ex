defmodule VltLabsWizard.Web.API.UsersController do
  use VltLabsWizard.Web, :controller

  alias VltLabsWizard.Auth

  def translate_error({val, _}) do
    val
  end

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def create(conn, %{"user" => user_params}) do
    case Auth.create_user(user_params) do
      {:ok, %Auth.User{id: id}} ->
        conn
        |> json(%{ user: %{id: id}})
      # |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> json(%{ error: translate_errors(changeset)})
      {:error, %{} = changeset} ->
        conn
        |> json(%{ error: changeset.errors})

      _ ->
        conn |> json(%{ e: "asd"})
    end
  end
end
