defmodule VltLabsWizard.Repo.Migrations.AddLinksAndJoinDateToEmployees do
  use Ecto.Migration

  def change do
    alter table(:hr_employees) do
      add :linkedin_link, :string
      add :resume_link, :string
      add :joined_on, :date
    end
  end
end
