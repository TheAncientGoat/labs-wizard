defmodule VltLabsWizard.Repo.Migrations.AddStartEndDateToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects_projects) do
      add :start_on, :date
      add :end_on, :date
    end
  end
end
