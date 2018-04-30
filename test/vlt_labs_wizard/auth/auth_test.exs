defmodule VltLabsWizard.AuthTest do
  use VltLabsWizard.DataCase

  alias VltLabsWizard.Auth

  describe "users" do
    alias VltLabsWizard.Auth.User

    @valid_attrs %{email: "some email", username: "some username", last_login_at: ~D[2010-04-17], login_count: 42, password: "some password"}
    @update_attrs %{email: "some updated email", username: "some username", last_login_at: ~D[2011-05-18], login_count: 43, password: "some updated password"}
    @invalid_attrs %{email: nil, last_login_at: nil, login_count: nil, password: nil}

    setup do
      employee = insert(:employee)
      :ok
    end

    def user_fixture(attrs \\ %{}) do
      attrs = %{}
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      Auth.get_user!(user.id)
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.last_login_at == ~D[2010-04-17]
      assert user.login_count == 42
      assert user.password == "some password"
      assert user.employee_id != nil
      assert VltLabsWizard.HR.get_employee!(user.employee_id).status == "Active"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Auth.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.last_login_at == ~D[2011-05-18]
      assert user.login_count == 43
      assert user.password == "some updated password"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end
end
