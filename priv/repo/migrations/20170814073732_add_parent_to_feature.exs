defmodule VltLabsWizard.Repo.Migrations.AddParentToFeature do
  use Ecto.Migration

  def change do
    alter table(:features) do
      add :parent_id, references(:features, on_delete: :nilify_all)
    end
  end
end
