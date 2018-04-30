defmodule VltLabsWizard.Repo.Migrations.AddTitleToMandays do
  use Ecto.Migration

  def change do
    alter table(:projects_man_days) do
      add :title, :string
    end
  end
end
