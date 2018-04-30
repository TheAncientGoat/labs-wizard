defmodule VltLabsWizard.HR do
  @moduledoc """
  The boundary for the HR system.
  """

  import Ecto.Query, warn: false
  alias VltLabsWizard.Repo

  alias VltLabsWizard.HR.Department

  @doc """
  Returns the list of departments.

  ## Examples

      iex> list_departments()
      [%Department{}, ...]

  """
  def list_departments do
    Department
    |> Repo.all
    |> Repo.preload(:employees)
  end

  @doc """
  Returns a list of pairs that can be used in a dropdown
  """
  def selectable_departments do
    list_departments()
    |> Enum.map(fn(dept) ->
      {dept.name, dept.id}
    end)
  end

  @doc """
  Gets a single department.

  Raises `Ecto.NoResultsError` if the Department does not exist.

  ## Examples

      iex> get_department!(123)
      %Department{}

      iex> get_department!(456)
      ** (Ecto.NoResultsError)

  """
  def get_department!(id), do: Repo.preload(
        Repo.get!(Department, id), :employees)

  @doc """
  Creates a department.

  ## Examples

      iex> create_department(%{field: value})
      {:ok, %Department{}}

      iex> create_department(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_department(attrs \\ %{}) do
    %Department{}
    |> Repo.preload(:employees)
    |> Department.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a department.

  ## Examples

      iex> update_department(department, %{field: new_value})
      {:ok, %Department{}}

      iex> update_department(department, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_department(%Department{} = department, attrs) do
    department
    |> Repo.preload(:employees)
    |> Department.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Department.

  ## Examples

      iex> delete_department(department)
      {:ok, %Department{}}

      iex> delete_department(department)
      {:error, %Ecto.Changeset{}}

  """
  def delete_department(%Department{} = department) do
    Repo.delete(department)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking department changes.

  ## Examples

      iex> change_department(department)
      %Ecto.Changeset{source: %Department{}}

  """
  def change_department(%Department{} = department) do
    Department.changeset(department, %{})
  end

  alias VltLabsWizard.HR.Employee

  @doc """
  Returns the list of employees.

  ## Examples

      iex> list_employees()
      [%Employee{}, ...]

  """
  def list_employees do
    Employee
    |> Repo.all
    |> Repo.preload([:department, :man_days])
  end

  def get_employee_by(attrs) do
    q = Map.to_list(attrs)
    query = from p in Employee,
      where: ^q
    x = query
    |> Repo.all
    |> List.first()
  end

  def selectable_employees do
    list_employees()
    |> Enum.map(fn(emp) ->
      {emp.nickname, emp.id}
    end)
  end
  @doc """
  Gets a single employee.

  Raises `Ecto.NoResultsError` if the Employee does not exist.

  ## Examples

      iex> get_employee!(123)
      %Employee{}

      iex> get_employee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_employee!(id), do: Repo.preload(
        Repo.get!(Employee, id),
        [:department, :man_days]
      )

  @doc """
  Creates a employee.

  ## Examples

      iex> create_employee(%{field: value})
      {:ok, %Employee{}}

      iex> create_employee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee(attrs \\ %{}) do
    %Employee{}
    |> Repo.preload([ :man_days, :department ])
    |> Employee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employee.

  ## Examples

      iex> update_employee(employee, %{field: new_value})
      {:ok, %Employee{}}

      iex> update_employee(employee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee(%Employee{} = employee, attrs) do
    employee
    |> Repo.preload(:department)
    |> Employee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Employee.

  ## Examples

      iex> delete_employee(employee)
      {:ok, %Employee{}}

      iex> delete_employee(employee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee(%Employee{} = employee) do
    Repo.delete(employee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employee changes.

  ## Examples

      iex> change_employee(employee)
      %Ecto.Changeset{source: %Employee{}}

  """
  def change_employee(%Employee{} = employee) do
    employee
    |> Repo.preload(:department)
    |> Employee.changeset(%{})
  end
end
