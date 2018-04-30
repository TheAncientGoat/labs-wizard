defmodule VltLabsWizard.Repo.Migrations.RemoveNotNullUsername do
  use Ecto.Migration

  def change do
    drop_if_exists index(:auth_users, [:username])
    alter table(:auth_users) do
      modify :username, :string, null: true
    end
  end
end
