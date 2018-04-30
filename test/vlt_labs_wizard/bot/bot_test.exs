defmodule VltLabsWizard.BotTest do
  use VltLabsWizard.DataCase

  alias VltLabsWizard.Bot

  describe "slack" do
    alias VltLabsWizard.Bot.Slack

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def slack_fixture(attrs \\ %{}) do
      {:ok, slack} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bot.create_slack()

      slack
    end

    test "list_slack/0 returns all slack" do
      slack = slack_fixture()
      assert Bot.list_slack() == [slack]
    end

    test "get_slack!/1 returns the slack with given id" do
      slack = slack_fixture()
      assert Bot.get_slack!(slack.id) == slack
    end

    test "create_slack/1 with valid data creates a slack" do
      assert {:ok, %Slack{} = slack} = Bot.create_slack(@valid_attrs)
    end

    test "create_slack/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bot.create_slack(@invalid_attrs)
    end

    test "update_slack/2 with valid data updates the slack" do
      slack = slack_fixture()
      assert {:ok, slack} = Bot.update_slack(slack, @update_attrs)
      assert %Slack{} = slack
    end

    test "update_slack/2 with invalid data returns error changeset" do
      slack = slack_fixture()
      assert {:error, %Ecto.Changeset{}} = Bot.update_slack(slack, @invalid_attrs)
      assert slack == Bot.get_slack!(slack.id)
    end

    test "delete_slack/1 deletes the slack" do
      slack = slack_fixture()
      assert {:ok, %Slack{}} = Bot.delete_slack(slack)
      assert_raise Ecto.NoResultsError, fn -> Bot.get_slack!(slack.id) end
    end

    test "change_slack/1 returns a slack changeset" do
      slack = slack_fixture()
      assert %Ecto.Changeset{} = Bot.change_slack(slack)
    end
  end
end
