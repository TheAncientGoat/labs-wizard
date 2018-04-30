defmodule VltLabsWizard.Repo.Migrations.AddFeatureToManday do
  use Ecto.Migration

  def change do
    alter table(:projects_man_days) do
      add :feature_id, references(:features, on_delete: :nilify_all)
    end
  end
end
