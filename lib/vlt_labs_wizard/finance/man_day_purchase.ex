defmodule VltLabsWizard.Finance.ManDayPurchase do
  use Ecto.Schema
  import Ecto.Changeset
  alias VltLabsWizard.Finance.ManDayPurchase

  @moduledoc "Tracks when a client bought mandays"

  schema "finance_man_day_purchase" do
    field :days_purchased, :decimal
    field :purchased_on, :date
    field :total_cost, :decimal

    belongs_to :project, VltLabsWizard.Projects.Project
    timestamps()
  end

  def public_fields do
    [:purchased_on, :days_purchased, :total_cost, :project_id, :id]
  end

  defimpl Poison.Encoder, for: ManDayPurchase do
    def encode(model, opts) do
      model
      |> Map.take(ManDayPurchase.public_fields())
      |> Poison.Encoder.encode(opts)
    end
  end

  @doc false
  def changeset(%ManDayPurchase{} = man_day_purchase, attrs \\ %{}) do
    man_day_purchase
    |> cast(attrs, public_fields() -- [:id])
    |> validate_required(public_fields() -- [:id])
  end
end
