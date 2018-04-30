defmodule VltLabsWizard.Web.ManDayController do
  use VltLabsWizard.Web, :controller

  alias VltLabsWizard.Projects

  def index(conn, _params) do
    man_days = Projects.list_man_days()
    render(conn, "index.html", man_days: man_days)
  end

  def new(conn, _params) do
    changeset = Projects.change_man_day(%VltLabsWizard.Projects.ManDay{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"man_day" => man_day_params}) do
    case Projects.create_man_day(man_day_params) do
      {:ok, man_day} ->
        conn
        |> put_flash(:info, "Man day created successfully.")
        |> redirect(to: man_day_path(conn, :show, man_day))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    man_day = Projects.get_man_day!(id)
    render(conn, "show.html", man_day: man_day)
  end

  def edit(conn, %{"id" => id}) do
    man_day = Projects.get_man_day!(id)
    changeset = Projects.change_man_day(man_day)
    render(conn, "edit.html", man_day: man_day, changeset: changeset)
  end

  def update(conn, %{"id" => id, "man_day" => man_day_params}) do
    man_day = Projects.get_man_day!(id)

    case Projects.update_man_day(man_day, man_day_params) do
      {:ok, man_day} ->
        conn
        |> put_flash(:info, "Man day updated successfully.")
        |> redirect(to: man_day_path(conn, :show, man_day))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", man_day: man_day, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    man_day = Projects.get_man_day!(id)
    {:ok, _man_day} = Projects.delete_man_day(man_day)

    conn
    |> put_flash(:info, "Man day deleted successfully.")
    |> redirect(to: man_day_path(conn, :index))
  end
end
