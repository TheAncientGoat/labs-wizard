defmodule VltLabsWizard.Web.API.ManDayController do
  use VltLabsWizard.Web, :controller

  alias VltLabsWizard.Projects
  alias VltLabsWizard.Projects.ManDay

  action_fallback VltLabsWizard.Web.FallbackController

  def index(conn, _params) do
    man_days = Projects.list_man_days()
    render(conn, "index.json", man_days: man_days)
  end

  def create(conn, %{"man_day" => man_day_params}) do
    with {:ok, %ManDay{} = man_day} <- Projects.create_man_day(man_day_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", man_day_path(conn, :show, man_day))
      |> render("show.json", man_day: man_day)
    end
  end

  def show(conn, %{"id" => id}) do
    man_day = Projects.get_man_day!(id)
    render(conn, "show.json", man_day: man_day)
  end

  def update(conn, %{"id" => id, "man_day" => man_day_params}) do
    man_day = Projects.get_man_day!(id)

    with {:ok, %ManDay{} = man_day} <- Projects.update_man_day(man_day, man_day_params) do
      render(conn, "show.json", man_day: man_day)
    end
  end

  def delete(conn, %{"id" => id}) do
    man_day = Projects.get_man_day!(id)
    with {:ok, %ManDay{}} <- Projects.delete_man_day(man_day) do
      send_resp(conn, :no_content, "")
    end
  end
end
