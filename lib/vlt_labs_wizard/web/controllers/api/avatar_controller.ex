defmodule VltLabsWizard.Web.AvatarApiController do
  @moduledoc "Handles uploads for user avatars"

  use VltLabsWizard.Web, :controller

  alias VltLabsWizard.HR
  alias VltLabsWizard.HR.Employee
  alias VltLabsWizard.Avatar

  def create(conn, %{"employee_id" => e_id, "avatar" => avatar}) do
    emp = HR.get_employee!(e_id)
    {:ok, name} = Avatar.store({avatar, emp})
    url = Avatar.url({name, emp})
    conn
    |> put_status(200)
    |> json(%{ avatar_url: url })
  end
end
