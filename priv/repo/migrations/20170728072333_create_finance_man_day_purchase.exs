defmodule VltLabsWizard.Repo.Migrations.CreateVltLabsWizard.Finance.ManDayPurchase do
  use Ecto.Migration

  def change do
    create table(:finance_man_day_purchase) do
      add :purchased_on, :date
      add :days_purchased, :decimal
      add :total_cost, :decimal
      add :project_id, references(:projects_projects, on_delete: :nothing)

      timestamps()
    end

    create index(:finance_man_day_purchase, [:project_id])
  end
end
