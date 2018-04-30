defmodule VltLabsWizard.Repo.Migrations.CreateFeatures do
  use Ecto.Migration

  def change do
    create table(:features) do
      add :name, :string
      add :estimated_days, :decimal
      add :start_on, :date
      add :end_on, :date
      add :notes, :text
      add :assignee_id, references(:hr_employees, on_delete: :delete_all)
      add :project_id, references(:projects_projects, on_delete: :delete_all)

      timestamps()
    end

    create index(:features, [:assignee_id])
    create index(:features, [:project_id])
  end
end
