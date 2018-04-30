defmodule VltLabsWizard.Repo.Migrations.AddStatusToEmployees do
  use Ecto.Migration

  def change do
    alter table(:hr_employees) do
      add :status, :string, default: "pending"
    end
  end
end
