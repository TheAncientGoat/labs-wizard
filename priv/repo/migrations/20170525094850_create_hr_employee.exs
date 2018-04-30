defmodule VltLabsWizard.Repo.Migrations.CreateVltLabsWizard.HR.Employee do
  use Ecto.Migration

  def change do
    create table(:hr_employees) do
      add :first_name, :string
      add :last_name, :string
      add :nickname, :string
      add :email, :string
      add :mobile, :string
      add :title, :string
      add :avatar, :string

      timestamps()
    end

  end
end
