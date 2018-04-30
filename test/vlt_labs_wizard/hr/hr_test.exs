defmodule VltLabsWizard.HRTest do
  use VltLabsWizard.DataCase

  alias VltLabsWizard.HR

  describe "departments" do
    alias VltLabsWizard.HR.Department

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def department_fixture(attrs \\ %{}) do
      {:ok, department} =
        attrs
        |> Enum.into(@valid_attrs)
        |> HR.create_department()

      department
    end

    test "list_departments/0 returns all departments" do
      department = department_fixture()
      assert HR.list_departments() == [department]
    end

    test "get_department!/1 returns the department with given id" do
      department = department_fixture()
      assert HR.get_department!(department.id) == department
    end

    test "create_department/1 with valid data creates a department" do
      assert {:ok, %Department{} = department} = HR.create_department(@valid_attrs)
      assert department.name == "some name"
    end

    test "create_department/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HR.create_department(@invalid_attrs)
    end

    test "update_department/2 with valid data updates the department" do
      department = department_fixture()
      assert {:ok, department} = HR.update_department(department, @update_attrs)
      assert %Department{} = department
      assert department.name == "some updated name"
    end

    test "update_department/2 with invalid data returns error changeset" do
      department = department_fixture()
      assert {:error, %Ecto.Changeset{}} = HR.update_department(department, @invalid_attrs)
      assert department == HR.get_department!(department.id)
    end

    test "delete_department/1 deletes the department" do
      department = department_fixture()
      assert {:ok, %Department{}} = HR.delete_department(department)
      assert_raise Ecto.NoResultsError, fn -> HR.get_department!(department.id) end
    end

    test "change_department/1 returns a department changeset" do
      department = department_fixture()
      assert %Ecto.Changeset{} = HR.change_department(department)
    end
  end

  describe "employees" do
    alias VltLabsWizard.HR.Employee

    @valid_attrs %{avatar: "some avatar", email: "some email", first_name: "some first_name", last_name: "some last_name", mobile: "some mobile", nickname: "some nickname", title: "some title"}
    @update_attrs %{avatar: "some updated avatar", email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", mobile: "some updated mobile", nickname: "some updated nickname", title: "some updated title"}
    @invalid_attrs %{avatar: nil, email: nil, first_name: nil, last_name: nil, mobile: nil, nickname: nil, title: nil}

    def employee_fixture(attrs \\ %{}) do
      {:ok, employee} =
        attrs
        |> Enum.into(%{department_id: insert(:department).id})
        |> Enum.into(@valid_attrs)
        |> HR.create_employee()

      HR.get_employee!(employee.id)
    end

    test "list_employees/0 returns all employees" do
      employee = employee_fixture()
      assert HR.list_employees() == [employee]
    end

    test "get_employee!/1 returns the employee with given id" do
      employee = employee_fixture()
      assert %{ avatar: _} = HR.get_employee!(employee.id)
    end

    test "create_employee/1 with valid data creates a employee" do
      assert {:ok, %Employee{} = employee} = HR.create_employee(
        Enum.into(@valid_attrs, %{department_id: insert(:department).id})
      )
      assert employee.avatar == "some avatar"
      assert employee.email == "some email"
      assert employee.first_name == "some first_name"
      assert employee.last_name == "some last_name"
      assert employee.mobile == "some mobile"
      assert employee.nickname == "some nickname"
      assert employee.title == "some title"
    end

    test "create_employee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HR.create_employee(@invalid_attrs)
    end

    test "update_employee/2 with valid data updates the employee" do
      employee = employee_fixture()
      assert {:ok, employee} = HR.update_employee(employee, @update_attrs)
      assert %Employee{} = employee
      assert employee.avatar == "some updated avatar"
      assert employee.email == "some updated email"
      assert employee.first_name == "some updated first_name"
      assert employee.last_name == "some updated last_name"
      assert employee.mobile == "some updated mobile"
      assert employee.nickname == "some updated nickname"
      assert employee.title == "some updated title"
    end

    test "update_employee/2 with invalid data returns error changeset" do
      employee = HR.get_employee!(employee_fixture().id)
      assert {:error, %Ecto.Changeset{}} = HR.update_employee(employee, @invalid_attrs)
      assert employee == HR.get_employee!(employee.id)
    end

    test "delete_employee/1 deletes the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{}} = HR.delete_employee(employee)
      assert_raise Ecto.NoResultsError, fn -> HR.get_employee!(employee.id) end
    end

    test "change_employee/1 returns a employee changeset" do
      employee = employee_fixture()
      assert %Ecto.Changeset{} = HR.change_employee(employee)
    end
  end
end
