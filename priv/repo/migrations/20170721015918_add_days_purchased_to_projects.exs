defmodule VltLabsWizard.Repo.Migrations.AddDaysPurchasedToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects_projects) do
      add :mandays_purchased, :decimal, default: 0
    end
  end
end
