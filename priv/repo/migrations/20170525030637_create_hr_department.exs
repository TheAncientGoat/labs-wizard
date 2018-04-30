defmodule VltLabsWizard.Repo.Migrations.CreateVltLabsWizard.HR.Department do
  use Ecto.Migration

  def change do
    create table(:hr_departments) do
      add :name, :string

      timestamps()
    end

  end
end
