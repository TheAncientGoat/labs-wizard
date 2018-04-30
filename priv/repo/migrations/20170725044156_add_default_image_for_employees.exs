defmodule VltLabsWizard.Repo.Migrations.AddDefaultImageForEmployees do
  use Ecto.Migration

  def change do
    alter table(:hr_employees) do
      modify :avatar, :string, default: "http://lorempixel.com/50/50/abstract"
    end
  end
end
