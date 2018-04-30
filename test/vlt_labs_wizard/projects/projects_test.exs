defmodule VltLabsWizard.ProjectsTest do
  use VltLabsWizard.DataCase
  alias VltLabsWizard.Projects

  describe "projects" do
    alias VltLabsWizard.Projects.Project

    @valid_attrs %{description: "some description", estimated_man_days: "120.5", manday_cost: "120.5", max_manday: 42, min_manday: 42, name: "some name", priority: 42, production_url: "some production_url", staging_url: "some staging_url", status: 2, mandays_purchased: 0}
    @update_attrs %{description: "some updated description", estimated_man_days: "456.7", manday_cost: "456.7", max_manday: 43, min_manday: 43, name: "some updated name", priority: 43, production_url: "some updated production_url", staging_url: "some updated staging_url", status: 0}
    @invalid_attrs %{description: nil, estimated_man_days: nil, manday_cost: nil, max_manday: nil, min_manday: nil, name: nil, priority: nil, production_url: nil, staging_url: nil, status: nil}

    def project_fixture(attrs \\ %{}) do
      {:ok, project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Projects.create_project()

      project
    end

    @tag :calc
    test "calculate_man_days/1 calculates man days for a project" do
      project = project_fixture()
      insert(:man_day, %{project: project})
      res = project.id
      |> Projects.get_project!
      |> Projects.calculate_man_days_for!
      assert Decimal.parse("120.5") == {:ok, res}
    end

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Projects.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      assert {:ok, %Project{} = project} = Projects.create_project(@valid_attrs)
      assert project.description == "some description"
      assert project.estimated_man_days == Decimal.new("120.5")
      assert project.manday_cost == Decimal.new("120.5")
      assert project.max_manday == 42
      assert project.min_manday == 42
      assert project.name == "some name"
      assert project.priority == 42
      assert project.production_url == "some production_url"
      assert project.staging_url == "some staging_url"
      assert project.status == :past
    end

    test "create_project/1 with valid data and employees creates a project" do
      assert {:ok, %Project{} = project} = Projects.create_project(
        Map.merge(@valid_attrs, %{employees: [insert(:employee).id]}))
      assert project.description == "some description"
      assert project.estimated_man_days == Decimal.new("120.5")
      assert project.manday_cost == Decimal.new("120.5")
      assert project.max_manday == 42
      assert project.min_manday == 42
      assert project.name == "some name"
      assert project.priority == 42
      assert project.production_url == "some production_url"
      assert project.staging_url == "some staging_url"
      assert project.status == :past
      assert length(Projects.get_project!(project.id).assignments) > 0
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data and employees updates the project" do
      project = project_fixture()
      employee = insert(:employee)
      assert {:ok, project} =
        Projects.update_project(
          project,
          Map.merge(@update_attrs, %{employees: [employee.id]})
          )
      assert %Project{} = project
      assert project.description == "some updated description"
      assert project.estimated_man_days == Decimal.new("456.7")
      assert project.manday_cost == Decimal.new("456.7")
      assert project.max_manday == 43
      assert project.min_manday == 43
      assert project.name == "some updated name"
      assert project.priority == 43
      assert project.production_url == "some updated production_url"
      assert project.staging_url == "some updated staging_url"
      IO.inspect(Projects.get_project!(project.id))
      assert List.last(Projects.get_project!(project.id).employees).id == [employee.id]
      assert project.status == :ongoing
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, project} = Projects.update_project(project, @update_attrs)
      assert %Project{} = project
      assert project.description == "some updated description"
      assert project.estimated_man_days == Decimal.new("456.7")
      assert project.manday_cost == Decimal.new("456.7")
      assert project.max_manday == 43
      assert project.min_manday == 43
      assert project.name == "some updated name"
      assert project.priority == 43
      assert project.production_url == "some updated production_url"
      assert project.staging_url == "some updated staging_url"
      assert project.status == :ongoing
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end

  describe "assignments" do
    alias VltLabsWizard.Projects.Assignment

    @valid_employee_attrs %{avatar: "some avatar", email: "some email", first_name: "some first_name", last_name: "some last_name", mobile: "some mobile", nickname: "some nickname", title: "some title"}

    @valid_attrs %{estimated_days: 42, estimated_end: ~D[2010-04-17],
                   estimated_start: ~D[2010-04-17],
                   project: Map.from_struct(build(:project)),
                   employee: Map.from_struct(build(:employee))}
    @update_attrs %{estimated_days: 43, estimated_end: ~D[2011-05-18],
                    estimated_start: ~D[2011-05-18]}
                    #employee: Map.from_struct(build(:employee)),
                    #VltLabsWizard.HR.create_employee(@valid_employee_attrs),
                    #project: Map.from_struct(build(:project))} #Projects.create_project()
    @invalid_attrs %{estimated_days: nil, estimated_end: nil, estimated_start: nil, employee_id: 1, project_id: 1}

    def assignment_fixture(attrs \\ %{}) do
      {:ok, assignment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Projects.create_assignment()

      assignment
    end

    test "list_assignments/0 returns all assignments" do
      assignment = assignment_fixture()
      assert Projects.list_assignments == [assignment]
    end

    test "get_assignment!/1 returns the assignment with given id" do
      assignment = assignment_fixture()
      assert Projects.get_assignment!(assignment.id) == assignment
    end

    test "create_assignment/1 with valid data creates a assignment" do
      assert {:ok, %Assignment{} = assignment} = Projects.create_assignment(@valid_attrs)
      assert assignment.estimated_days == 42
      assert assignment.estimated_end == ~D[2010-04-17]
      assert assignment.estimated_start == ~D[2010-04-17]
    end

    test "create_assignment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_assignment(@invalid_attrs)
    end

    test "update_assignment/2 with valid data updates the assignment" do
      assignment = assignment_fixture()
      assert {:ok, assignment} = Projects.update_assignment(assignment, @update_attrs)
      assert %Assignment{} = assignment
      assert assignment.estimated_days == 43
      assert assignment.estimated_end == ~D[2011-05-18]
      assert assignment.estimated_start == ~D[2011-05-18]
    end

    test "update_assignment/2 with invalid data returns error changeset" do
      assignment = assignment_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_assignment(assignment, @invalid_attrs)
      assert assignment == Projects.get_assignment!(assignment.id)
    end

    test "delete_assignment/1 deletes the assignment" do
      assignment = assignment_fixture()
      assert {:ok, %Assignment{}} = Projects.delete_assignment(assignment)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_assignment!(assignment.id) end
    end

    test "change_assignment/1 returns a assignment changeset" do
      assignment = assignment_fixture()
      assert %Ecto.Changeset{} = Projects.change_assignment(assignment)
    end
  end


  describe "man_days" do
    alias VltLabsWizard.Projects.ManDay

    @update_attrs %{days: "456.7", notes: "some updated notes", performed_on: ~D[2011-05-18]}
    @invalid_attrs %{days: nil, notes: nil, performed_on: nil}

    def man_day_fixture(attrs \\ %{}) do
      :man_day
      |> insert
      |> Map.take(ManDay.public_fields)
    end

    def to_public(man_day) do
      Map.take(man_day, ManDay.public_fields)
    end

    test "list_man_days/0 returns all man_days" do
      man_day = man_day_fixture()
      assert Projects.list_man_days() |> Enum.map(&(Map.take(&1, ManDay.public_fields))) == [man_day]
    end

    test "get_man_day!/1 returns the man_day with given id" do
      man_day = man_day_fixture()
      assert Projects.get_man_day!(man_day.id) |> to_public == man_day
    end

    test "create_man_day/1 with valid data creates a man_day" do
      { _, valid_attributes } = Map.split(man_day_fixture, [:id])
      assert {:ok, %ManDay{} = man_day} = Projects.create_man_day(valid_attributes)
      assert man_day.days == Decimal.new("120.5")
      assert man_day.notes == "some notes"
      assert man_day.performed_on == ~D[2010-04-17]
    end

    test "create_man_day/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_man_day(@invalid_attrs)
    end

    test "update_man_day/2 with valid data updates the man_day" do
      assert {:ok, man_day} = Projects.update_man_day(insert(:man_day), @update_attrs)
      assert %ManDay{} = man_day
      assert man_day.days == Decimal.new("456.7")
      assert man_day.notes == "some updated notes"
      assert man_day.performed_on == ~D[2011-05-18]
    end

    test "update_man_day/2 with invalid data returns error changeset" do
      man_day = Projects.get_man_day!(insert(:man_day).id)
      assert {:error, %Ecto.Changeset{}} = Projects.update_man_day(man_day, @invalid_attrs)
      assert man_day == Projects.get_man_day!(man_day.id)
    end

    test "delete_man_day/1 deletes the man_day" do
      man_day = insert(:man_day)
      assert {:ok, %ManDay{}} = Projects.delete_man_day(man_day)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_man_day!(man_day.id) end
    end

    test "change_man_day/1 returns a man_day changeset" do
      man_day = build(:man_day)
      assert %Ecto.Changeset{} = Projects.change_man_day(man_day)
    end
  end

  describe "features" do
    alias VltLabsWizard.Projects.Feature

    @valid_attrs %{end_on: ~D[2010-04-17], estimated_days: "120.5", name: "some name", notes: "some notes", start_on: ~D[2010-04-17]}
    @update_attrs %{end_on: ~D[2011-05-18], estimated_days: "456.7", name: "some updated name", notes: "some updated notes", start_on: ~D[2011-05-18]}
    @invalid_attrs %{end_on: nil, estimated_days: nil, name: nil, notes: nil, start_on: nil}

    def feature_fixture(attrs \\ %{}) do
      {:ok, feature} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Projects.create_feature()

      feature
    end

    test "list_features/0 returns all features" do
      feature = feature_fixture()
      assert Projects.list_features() == [feature]
    end

    test "get_feature!/1 returns the feature with given id" do
      feature = feature_fixture()
      assert Projects.get_feature!(feature.id) == feature
    end

    test "create_feature/1 with valid data creates a feature" do
      assert {:ok, %Feature{} = feature} =
        Projects.create_feature(Map.merge(@valid_attrs, %{project_id: insert(:project).id}))
      assert feature.end_on == ~D[2010-04-17]
      assert feature.estimated_days == Decimal.new("120.5")
      assert feature.name == "some name"
      assert feature.notes == "some notes"
      assert VltLabsWizard.Repo.preload(feature, :project).project.name == "some name"
      assert feature.start_on == ~D[2010-04-17]
    end

    test "create_feature/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_feature(@invalid_attrs)
    end

    test "update_feature/2 with valid data updates the feature" do
      feature = feature_fixture()
      assert {:ok, feature} = Projects.update_feature(feature, @update_attrs)
      assert %Feature{} = feature
      assert feature.end_on == ~D[2011-05-18]
      assert feature.estimated_days == Decimal.new("456.7")
      assert feature.name == "some updated name"
      assert feature.notes == "some updated notes"
      assert feature.start_on == ~D[2011-05-18]
    end

    test "update_feature/2 with invalid data returns error changeset" do
      feature = feature_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_feature(feature, @invalid_attrs)
      assert feature == Projects.get_feature!(feature.id)
    end

    test "delete_feature/1 deletes the feature" do
      feature = feature_fixture()
      assert {:ok, %Feature{}} = Projects.delete_feature(feature)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_feature!(feature.id) end
    end

    test "change_feature/1 returns a feature changeset" do
      feature = feature_fixture()
      assert %Ecto.Changeset{} = Projects.change_feature(feature)
    end
  end
end
