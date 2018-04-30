defmodule VltLabsWizard.Repo.Migrations.AddDepartmentRelationToEmployees do
  use Ecto.Migration

  def change do
    alter table(:hr_employees) do
      add :department_id, references(:hr_departments)
    end
  end
end
