defmodule VltLabsWizard.Auth.User do
  @moduledoc "Authenticatable users"
  use Ecto.Schema
  import Ecto.Changeset
  alias VltLabsWizard.Auth.User


  schema "auth_users" do
    field :email, :string
    field :username, :string
    field :last_login_at, :date
    field :login_count, :integer
    field :password, :string, virtual: true
    field :password_hash, :string

    belongs_to :employee, VltLabsWizard.HR.Employee

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :username, :last_login_at,
                   :login_count, :password, :employee_id])
    |> validate_required([:email])
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{
        valid?: true,
        changes: %{password: password}
      } ->
        put_change(changeset, :password_hash,
          Comeonin.Bcrypt.hashpwsalt(password)
        )
      _ ->
        changeset
    end
  end
end
