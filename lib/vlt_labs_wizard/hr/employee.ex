defmodule VltLabsWizard.HR.Employee do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias VltLabsWizard.HR.Employee
  alias VltLabsWizard.HR.Department

  schema "hr_employees" do

    field :first_name, :string
    field :last_name, :string
    field :avatar, :string
    field :email, :string
    field :mobile, :string
    field :nickname, :string
    field :slack, :string
    field :title, :string
    field :status, :string

    field :joined_on, Ecto.Date
    field :linkedin_link, :string
    field :resume_link, :string

    belongs_to :department, Department
    has_many :man_days, VltLabsWizard.Projects.ManDay
    has_many :assignments, VltLabsWizard.Projects.Assignment
    has_many :projects, through: [:assignments, :project]

    timestamps()
  end

  defimpl Poison.Encoder, for: Employee do
    def encode(model, opts) do
      fixed_avatar =
        case URI.parse(model.avatar) do
          %{host: nil} ->
            Map.merge(model, %{avatar: "http://lorempixel.com/50/50/abstract"})
          %{host: _} ->
            model
        end

      fixed_man_days =
        case fixed_avatar.man_days do
          %Ecto.Association.NotLoaded{} -> Map.merge(fixed_avatar, %{man_days: []})
          _ -> fixed_avatar
        end

      get_dept_name = fn id -> VltLabsWizard.HR.get_department!(id).name end

      fixed_man_days
      |> Map.merge(%{department: get_dept_name.(model.department_id)})
      |> Map.take([:id, :first_name, :last_name, :nickname, :status, :slack,
                  :linkedin_link, :resume_link, :joined_on, :man_days,
                  :email, :mobile, :title, :avatar, :department_id, :department]
                   )
      |> Poison.Encoder.encode(opts)
    end
  end

  @doc false
  def changeset(%Employee{} = employee, attrs \\ %{}) do
    employee
    |> cast(attrs, [:first_name, :last_name, :nickname, :status, :slack,
                   :joined_on, :linkedin_link, :resume_link,
                   :email, :mobile, :title, :department_id, :avatar])
    # |> cast_attachments(attrs, [:avatar ])
    |> validate_required([:first_name, :last_name,
                         :email, :title, :department_id])
  end
end
