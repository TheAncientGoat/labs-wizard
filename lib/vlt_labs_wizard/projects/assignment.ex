defmodule VltLabsWizard.Projects.Assignment do
  @moduledoc """
  Join Table for employees -> projects
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias VltLabsWizard.Projects.Assignment

  @behaviour Access

  defdelegate fetch(term, key), to: Map
  defdelegate get(term, key, default), to: Map
  defdelegate get_and_update(term, key, fun), to: Map

  def pop(_, _) do
    raise "Why are you trying to `pop` a struct?"
  end

  schema "projects_assignments" do
    field :estimated_days, :integer
    field :estimated_end, :date
    field :estimated_start, :date

    belongs_to :project, VltLabsWizard.Projects.Project
    belongs_to :employee, VltLabsWizard.HR.Employee
    timestamps()
  end

  def mod_fields do
    [:estimated_start, :estimated_end, :estimated_days,
     :employee_id, :project_id]
  end

  defimpl Poison.Encoder, for: VltLabsWizard.Projects.Assignment do
    def encode(model, opts) do
      model
      |> Map.take(VltLabsWizard.Projects.Assignment.mod_fields)
      |> Poison.Encoder.encode(opts)
    end
  end

  @doc false
  def changeset(%Assignment{} = assignment, attrs \\ %{}) do
    assignment
    |> cast(attrs, mod_fields())
  end
end
