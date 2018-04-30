defmodule VltLabsWizard.Projects do
  @moduledoc """
  The boundary for the Projects system.
  """

  import Ecto.Query, warn: false
  alias VltLabsWizard.Repo

  alias VltLabsWizard.Projects.Project

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Project
    |> Repo.all
    |> Repo.preload([:employees, :assignments, :man_days, :purchases, :features])
  end

  def selectable_projects do
    list_projects()
    |> Enum.map(fn(project) ->
      {project.name, project.id}
    end)
  end

  @doc """
  Calculates total man days spent on a given project
  ## Examples
    iex> calculate_man_days_for!(get_project(1))
    1
  """

  def calculate_man_days_for!(project) do
    project.man_days
    |> Enum.reduce(Decimal.new(0), &(Decimal.add(&1.days, &2)))
  end

  @doc """
  Calculates total man days spent on a given project
  ## Examples
  iex> calculate_man_days_for!(get_project(1))
  1
  """

  def calculate_man_days_purchased_for!(project) do
    project.purchases
    |> Enum.reduce(project.mandays_purchased, &(Decimal.add(&1.days_purchased, &2)))
  end


  def increment_man_day(project, man_day) do
    update_project(project,
      %{man_days: Decimal.add(project.mandays_purchased, man_day.days_purchased)})
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.preload(Repo.get!(Project, id), [:employees, :assignments, :man_days, :purchases, :features])


  def create_assignments({:ok, p} = project) do
    fn id -> create_assignment(%{employee_id: id, project_id: p.id}) end
  end
  def create_assignments(p) do
    create_assignments({:ok, p})
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    proj = %Project{}
    |> Repo.preload([:employees, :assignments, :man_days, :purchases, :features])
    |> Project.changeset(attrs)
    |> Repo.insert

    case attrs do
      %{"employees" => employees} -> Enum.each(employees, create_assignments(proj))
      %{:employees => employees} -> Enum.each(employees, create_assignments(proj))
      _ -> attrs
    end

    proj
    # Disregard below - just preload before insert...
    # This craziness is to ensure that tests pass :\
    # doesn't really make sense because there will never be any data
    # to preload on newly created projects
  #   case proj do
  #     {:ok, project} ->
  #         {:ok, Repo.preload(project, [:employees, :assignments, :man_days])}
  #     {:error, project} ->
  #       {:error, project}
  #   end
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    update = project
    |> Project.changeset(attrs)
    # |> Repo.preload([:employees, :assignments, :man_days])
    |> Repo.update()

    if attrs["employees"] do
      emp_ids = project.employees
      |> Enum.map(&(&1.id))

      unassigned_emps = emp_ids -- attrs["employees"]

      new_emps = attrs["employees"] -- emp_ids

      new_emps
      |> Enum.each(create_assignments(project))


      unassigned_ids = project.assignments
      |> Enum.filter(&(Enum.member? unassigned_emps, &1.employee_id))


      q = from(p in VltLabsWizard.Projects.Assignment,
        where: p.employee_id in ^unassigned_emps and p.project_id == ^project.id
      )

      q
      |> Repo.delete_all
    end

    update
  end

  @doc """
  Deletes a Project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{source: %Project{}}

  """
  def change_project(%Project{} = project) do
    Project.changeset(project, %{})
  end

  alias VltLabsWizard.Projects.Assignment

  @doc """
  Returns the list of assignments.

  ## Examples

      iex> list_assignments()
      [%Assignment{}, ...]

  """
  def list_assignments do
    Assignment
    |> Repo.all
    |> Repo.preload([:project, {:employee, :department}])
  end

  @doc """
  Gets a single assignment.

  Raises `Ecto.NoResultsError` if the Assignment does not exist.

  ## Examples

      iex> get_assignment!(123)
      %Assignment{}

      iex> get_assignment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_assignment!(id), do: Repo.preload(Repo.get!(Assignment, id), [{:employee, :department}, :project])

  @doc """
  Creates a assignment.

  ## Examples

      iex> create_assignment(%{field: value})
      {:ok, %Assignment{}}

      iex> create_assignment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_assignment(attrs \\ %{}) do
    x = %Assignment{}
    |> Repo.preload([:employee, :project])
    |> Assignment.changeset(attrs)
    |> Repo.insert()

    x
  end

  @doc """
  Updates a assignment.

  ## Examples

      iex> update_assignment(assignment, %{field: new_value})
      {:ok, %Assignment{}}

      iex> update_assignment(assignment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_assignment(%Assignment{} = assignment, attrs) do
    assignment
    |> Repo.preload([:project, :employee])
    |> Assignment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Assignment.

  ## Examples

      iex> delete_assignment(assignment)
      {:ok, %Assignment{}}

      iex> delete_assignment(assignment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_assignment(%Assignment{} = assignment) do
    Repo.delete(assignment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking assignment changes.

  ## Examples

      iex> change_assignment(assignment)
      %Ecto.Changeset{source: %Assignment{}}

  """
  def change_assignment(%Assignment{} = assignment) do
    assignment
    |> Repo.preload([:employee, :project])
    |> Assignment.changeset(%{})
  end

  alias VltLabsWizard.Projects.ManDay

  @doc """
  Returns the list of man_days.

  ## Examples

      iex> list_man_days()
      [%ManDay{}, ...]

  """
  def list_man_days do
    Repo.all(ManDay)
  end

  @doc """
  Gets a single man_day.

  Raises `Ecto.NoResultsError` if the Man day does not exist.

  ## Examples

      iex> get_man_day!(123)
      %ManDay{}

      iex> get_man_day!(456)
      ** (Ecto.NoResultsError)

  """
  def get_man_day!(id), do: Repo.get!(ManDay, id)

  @doc """
  Creates a man_day.

  ## Examples

      iex> create_man_day(%{field: value})
      {:ok, %ManDay{}}

      iex> create_man_day(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_man_day(attrs \\ %{}) do
    %ManDay{}
    |> ManDay.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a man_day.

  ## Examples

      iex> update_man_day(man_day, %{field: new_value})
      {:ok, %ManDay{}}

      iex> update_man_day(man_day, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_man_day(%ManDay{} = man_day, attrs) do
    man_day
    |> Repo.preload([:employee, :project])
    |> ManDay.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ManDay.

  ## Examples

      iex> delete_man_day(man_day)
      {:ok, %ManDay{}}

      iex> delete_man_day(man_day)
      {:error, %Ecto.Changeset{}}

  """
  def delete_man_day(%ManDay{} = man_day) do
    Repo.delete(man_day)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking man_day changes.

  ## Examples

      iex> change_man_day(man_day)
      %Ecto.Changeset{source: %ManDay{}}

  """
  def change_man_day(%ManDay{} = man_day) do
    ManDay.changeset(man_day, %{})
  end

  alias VltLabsWizard.Projects.Feature

  @doc """
  Returns the list of features.

  ## Examples

      iex> list_features()
      [%Feature{}, ...]

  """
  def list_features do
    Repo.all(Feature)
  end

  @doc """
  Gets a single feature.

  Raises `Ecto.NoResultsError` if the Feature does not exist.

  ## Examples

      iex> get_feature!(123)
      %Feature{}

      iex> get_feature!(456)
      ** (Ecto.NoResultsError)

  """
  def get_feature!(id), do: Repo.get!(Feature, id)

  @doc """
  Creates a feature.

  ## Examples

      iex> create_feature(%{field: value})
      {:ok, %Feature{}}

      iex> create_feature(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_feature(attrs \\ %{}) do
    %Feature{}
    |> Feature.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a feature.

  ## Examples

      iex> update_feature(feature, %{field: new_value})
      {:ok, %Feature{}}

      iex> update_feature(feature, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_feature(%Feature{} = feature, attrs) do
    feature
    |> Feature.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Feature.

  ## Examples

      iex> delete_feature(feature)
      {:ok, %Feature{}}

      iex> delete_feature(feature)
      {:error, %Ecto.Changeset{}}

  """
  def delete_feature(%Feature{} = feature) do
    Repo.delete(feature)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking feature changes.

  ## Examples

      iex> change_feature(feature)
      %Ecto.Changeset{source: %Feature{}}

  """
  def change_feature(%Feature{} = feature) do
    Feature.changeset(feature, %{})
  end
end
