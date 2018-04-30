defmodule VltLabsWizard.Projects.Project do
  @moduledoc "tracks a project, and provides access to employees, mandays, assignments"
  use Ecto.Schema

  @behaviour Access

  defdelegate fetch(term, key), to: Map
  defdelegate get(term, key, default), to: Map
  defdelegate get_and_update(term, key, fun), to: Map

  def pop(_, _) do
    raise "Why are you trying to `pop` a struct?"
  end

  import Ecto.Changeset
  alias VltLabsWizard.Projects
  alias VltLabsWizard.Projects.Project

  schema "projects_projects" do
    field :description, :string
    field :estimated_man_days, :decimal
    field :manday_cost, :decimal
    field :max_manday, :integer
    field :min_manday, :integer
    field :mandays_purchased, :decimal
    field :name, :string
    field :priority, :integer
    field :project_image, :string
    field :production_url, :string
    field :staging_url, :string
    field :status, StatusEnum

    field :start_on, :date
    field :end_on, :date

    field :ios_formula, :decimal
    field :android_formula, :decimal
    field :unit_test_formula, :decimal
    field :system_test_formula, :decimal
    field :design_formula, :decimal
    field :pm_formula, :decimal

    has_many :purchases, VltLabsWizard.Finance.ManDayPurchase
    has_many :man_days, VltLabsWizard.Projects.ManDay
    has_many :features, VltLabsWizard.Projects.Feature
    has_many :assignments, VltLabsWizard.Projects.Assignment
    has_many :employees, through: [:assignments, :employee]

    timestamps()
  end

  def public_fields() do
    [:id, :name, :estimated_man_days, :staging_url, :description,
     :production_url, :manday_cost, :status, :priority, :project_image,
     :min_manday, :max_manday, :mandays_purchased,
     :start_on, :end_on, :ios_formula, :android_formula, :unit_test_formula,
     :system_test_formula, :design_formula, :pm_formula, :employees, :man_days,
     :purchases, :features
    ]
  end

  defimpl Poison.Encoder, for: Project do
    def encode(model, opts) do
      man_days = %{
        man_days_used:
          Projects.calculate_man_days_for!(model),
        total_man_days_purchased:
          Projects.calculate_man_days_purchased_for!(model)
      }
      model
      |> Map.merge(man_days)
      |> Map.take(
        Project.public_fields() ++ [:man_days_used, :total_man_days_purchased]
      )
      |> Poison.Encoder.encode(opts)
    end
  end

  @doc false
  def changeset(%Project{} = project, attrs \\ %{}) do
    project
    |> cast(attrs, public_fields() -- ~w(id employees man_days assignments purchases features)a)
    |> validate_required([:name, :description,
                         :min_manday, :max_manday])
  end
end
