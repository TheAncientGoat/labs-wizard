defmodule VltLabsWizard.Projects.ManDay do
  @moduledoc "tracks a manday spent by an employee"

  use Ecto.Schema
  import Ecto.Changeset
  alias VltLabsWizard.Projects.ManDay


  schema "projects_man_days" do
    field :days, :decimal
    field :notes, :string
    field :title, :string
    field :performed_on, Ecto.Date # :date

    belongs_to :employee, VltLabsWizard.HR.Employee
    belongs_to :project, VltLabsWizard.Projects.Project
    belongs_to :feature, VltLabsWizard.Projects.Feature
    timestamps()
  end

  def public_fields do
    [:id, :performed_on, :title, :days, :notes,
     :employee_id, :project_id, :feature_id]
  end

  defimpl Poison.Encoder, for: ManDay do
    def encode(model, opts) do
      model
      |> Map.take(ManDay.public_fields)
      |> Poison.Encoder.encode(opts)
    end
  end

  @doc false
  def changeset(%ManDay{} = man_day, attrs \\ %{}) do
    man_day
    |> cast(attrs, public_fields)
    |> validate_required(public_fields -- [:id, :feature_id])
  end

end
