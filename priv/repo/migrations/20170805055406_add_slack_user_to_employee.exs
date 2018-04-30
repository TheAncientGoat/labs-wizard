defmodule VltLabsWizard.Repo.Migrations.AddSlackUserToEmployee do
  use Ecto.Migration

  def change do
    alter table(:hr_employees) do
      add :slack, :string
    end
  end
end
