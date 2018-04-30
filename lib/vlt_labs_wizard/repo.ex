defmodule VltLabsWizard.Repo do
  use Ecto.Repo, otp_app: :vlt_labs_wizard
  use Scrivener, page_size: 10  # <--- add this

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  TODO: might be better to load this from application config?
  """
  def init(_, opts) do
    start = Keyword.put(opts,
      :url, System.get_env("DATABASE_URL")
    )
    x = start
    |> Keyword.put(:adapter, Ecto.Adapters.Postgres)
    |> Keyword.put(:pool_size, String.to_integer(System.get_env("POOL_SIZE") || "10"))
    {:ok, x}
  end
end
