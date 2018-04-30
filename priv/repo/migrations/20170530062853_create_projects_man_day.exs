defmodule VltLabsWizard.Repo.Migrations.CreateVltLabsWizard.Projects.ManDay do
  use Ecto.Migration

  def change do
    create table(:projects_man_days) do
      add :performed_on, :date
      add :days, :decimal
      add :notes, :text
      add :employee_id, references(:hr_employees, on_delete: :nothing)
      add :project_id, references(:projects_projects, on_delete: :nothing)

      timestamps()
    end

    create index(:projects_man_days, [:employee_id])
    create index(:projects_man_days, [:project_id])
  end
end
