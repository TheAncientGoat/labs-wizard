defmodule VltLabsWizard.Web.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import VltLabsWizard.Web.Router.Helpers

      import VltLabsWizard.Factory
      # The default endpoint for testing
      @endpoint VltLabsWizard.Web.Endpoint

      def login(user), do: build_conn() |> login(user)
      def login(%Plug.Conn{} = conn, user) do
        conn
        |> get(session_path(conn, :new))
        |> Map.update!(:state, fn (_) -> :set end)
        |> Guardian.Plug.sign_in(user)
        |> send_resp(200, "Flush the session")
        |> recycle()
      end
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(VltLabsWizard.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(VltLabsWizard.Repo, {:shared, self()})
    end
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

end
