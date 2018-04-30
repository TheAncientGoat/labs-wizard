defmodule VltLabsWizard.HR.Department do
  use Ecto.Schema
  import Ecto.Changeset
  alias VltLabsWizard.HR.Department


  schema "hr_departments" do
    field :name, :string

    has_many :employees, VltLabsWizard.HR.Employee
    timestamps()
  end

  @doc false
  def changeset(%Department{} = department, attrs \\ %{}) do
    department
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
