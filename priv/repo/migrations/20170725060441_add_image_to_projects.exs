defmodule VltLabsWizard.Repo.Migrations.AddImageToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects_projects) do
      add :project_image, :string, default: "http://lorempixel.com/100/100/abstract"
    end
  end
end
