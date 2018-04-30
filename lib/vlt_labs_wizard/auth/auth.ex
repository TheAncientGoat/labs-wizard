defmodule VltLabsWizard.Auth do
  @moduledoc "Authentication module helpers"

  import Ecto.Query, warn: false
  alias VltLabsWizard.Repo

  alias VltLabsWizard.Auth.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user, by any key value pair

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

  iex> get_user_by(email: 'asd@asd.com')
  %User{}

  iex> get_user_by(email: 'asdasd')
  ** (Ecto.NoResultsError)

  """
  def get_user_by(hash), do: Repo.get_by!(User, hash)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    # for some reason, sometimes get atom key maps and sometimes string key maps
    # lets convert to atoms only
    vals = for {key, val} <- attrs, into: %{} do
      cond do
        is_atom(key) -> {key, val}
        true -> {String.to_atom(key), val}
      end
    end

    employee =
    if vals[:email] do
      VltLabsWizard.HR.get_employee_by(%{email: vals[:email]})
    end
    if employee do
      res = %User{}
      |> User.changeset(Map.merge(vals, %{employee_id: employee.id}))
      |> Repo.insert()
      case res do
        {:ok, _} -> VltLabsWizard.HR.update_employee(employee, %{status: "Active"})
        x -> x
      end
      res
    else
      {:error, %{
          errors: ["This is not a valid employee email. Please contact admin"]
       }
      }
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
