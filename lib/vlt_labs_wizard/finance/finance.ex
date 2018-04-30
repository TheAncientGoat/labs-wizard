defmodule VltLabsWizard.Finance do
  @moduledoc """
  The boundary for the Finance system.
  """

  import Ecto.Query, warn: false
  alias VltLabsWizard.Repo

  alias VltLabsWizard.Finance.ManDayPurchase

  @doc """
  Returns the list of man_day_purchase.

  ## Examples

      iex> list_man_day_purchase()
      [%ManDayPurchase{}, ...]

  """
  def list_man_day_purchase do
    Repo.all(ManDayPurchase)
  end

  @doc """
  Gets a single man_day_purchase.

  Raises `Ecto.NoResultsError` if the Man day purchase does not exist.

  ## Examples

      iex> get_man_day_purchase!(123)
      %ManDayPurchase{}

      iex> get_man_day_purchase!(456)
      ** (Ecto.NoResultsError)

  """
  def get_man_day_purchase!(id), do: Repo.get!(ManDayPurchase, id)

  @doc """
  Creates a man_day_purchase.

  ## Examples

      iex> create_man_day_purchase(%{field: value})
      {:ok, %ManDayPurchase{}}

      iex> create_man_day_purchase(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_man_day_purchase(attrs \\ %{}) do
    p = %ManDayPurchase{}
    |> ManDayPurchase.changeset(attrs)
    |> Repo.insert()

    case p do
      {:ok, p} -> VltLabsWizard.Projects.increment_man_day(Repo.preload(p, :project).project, p)
      _ -> p
    end

    p
  end

  @doc """
  Updates a man_day_purchase.

  ## Examples

      iex> update_man_day_purchase(man_day_purchase, %{field: new_value})
      {:ok, %ManDayPurchase{}}

      iex> update_man_day_purchase(man_day_purchase, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_man_day_purchase(%ManDayPurchase{} = man_day_purchase, attrs) do
    man_day_purchase
    |> ManDayPurchase.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ManDayPurchase.

  ## Examples

      iex> delete_man_day_purchase(man_day_purchase)
      {:ok, %ManDayPurchase{}}

      iex> delete_man_day_purchase(man_day_purchase)
      {:error, %Ecto.Changeset{}}

  """
  def delete_man_day_purchase(%ManDayPurchase{} = man_day_purchase) do
    Repo.delete(man_day_purchase)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking man_day_purchase changes.

  ## Examples

      iex> change_man_day_purchase(man_day_purchase)
      %Ecto.Changeset{source: %ManDayPurchase{}}

  """
  def change_man_day_purchase(%ManDayPurchase{} = man_day_purchase) do
    ManDayPurchase.changeset(man_day_purchase, %{})
  end
end
