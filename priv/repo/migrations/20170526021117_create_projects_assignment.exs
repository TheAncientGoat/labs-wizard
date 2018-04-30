defmodule VltLabsWizard.Repo.Migrations.CreateVltLabsWizard.Projects.Assignment do
  use Ecto.Migration

  def change do
    create table(:projects_assignments) do
      add :estimated_start, :date
      add :estimated_end, :date
      add :estimated_days, :integer
      add :employee_id, references(:hr_employees, on_delete: :nothing)
      add :project_id, references(:projects_projects, on_delete: :nothing)

      timestamps()
    end

    create index(:projects_assignments, [:employee_id])
    create index(:projects_assignments, [:project_id])
  end
end
