defmodule VltLabsWizard.Projects.Feature do
  use Ecto.Schema
  import Ecto.Changeset
  alias VltLabsWizard.Projects.Feature

  schema "features" do
    field :name, :string
    field :notes, :string
    field :end_on, :date
    field :estimated_days, :decimal
    field :start_on, Ecto.Date

    belongs_to :project, VltLabsWizard.Projects.Project
    belongs_to :assignee, VltLabsWizard.HR.Employee
    belongs_to :parent, Feature
    timestamps()
  end

  def public_fields do
    [:name, :estimated_days, :start_on, :end_on,
     :notes, :assignee_id, :project_id, :parent_id, :id]
  end

  defimpl Poison.Encoder, for: Feature do
    def encode(model, opts) do
      model
      |> Map.take(Feature.public_fields())
      |> Poison.Encoder.encode(opts)
    end
  end

  @doc false
  def changeset(%Feature{} = feature, attrs \\ %{}) do
    feature
    |> cast(attrs, public_fields)
    |> validate_required([:name, :start_on, :project_id])
  end
end
