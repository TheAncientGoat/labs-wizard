defmodule VltLabsWizard.Repo.Migrations.CreateVltLabsWizard.Auth.User do
  use Ecto.Migration

  def change do
    create table(:auth_users) do
      add :email, :string, null: false
      add :username, :string, null: false
      add :last_login_at, :date
      add :login_count, :integer, default: 0
      add :password_hash, :string
      add :employee_id, references(:hr_employees, on_delete: :nothing)

      timestamps()
    end

    create index(:auth_users, [:employee_id])
    create unique_index(:auth_users, [:email])
    create unique_index(:auth_users, [:username])
  end
end
