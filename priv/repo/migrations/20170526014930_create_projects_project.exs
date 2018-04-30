defmodule VltLabsWizard.Repo.Migrations.CreateVltLabsWizard.Projects.Project do
  use Ecto.Migration

  def change do
    create table(:projects_projects) do
      add :name, :string
      add :estimated_man_days, :decimal
      add :staging_url, :string
      add :description, :text
      add :production_url, :string
      add :manday_cost, :decimal
      add :status, :integer
      add :priority, :integer
      add :min_manday, :integer
      add :max_manday, :integer
      add :ios_formula, :decimal
      add :android_formula, :decimal
      add :unit_test_formula, :decimal
      add :system_test_formula, :decimal
      add :design_formula, :decimal
      add :pm_formula, :decimal

      timestamps()
    end

  end
end
