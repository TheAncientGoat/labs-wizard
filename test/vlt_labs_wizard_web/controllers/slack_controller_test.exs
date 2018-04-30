defmodule VltLabsWizardWeb.SlackControllerTest do
  use VltLabsWizardWeb.ConnCase

  alias VltLabsWizard.Bot
  alias VltLabsWizard.Bot.Slack

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:slack) do
    {:ok, slack} = Bot.create_slack(@create_attrs)
    slack
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all slack", %{conn: conn} do
      conn = get conn, slack_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create slack" do
    test "renders slack when data is valid", %{conn: conn} do
      conn = post conn, slack_path(conn, :create), slack: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, slack_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, slack_path(conn, :create), slack: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update slack" do
    setup [:create_slack]

    test "renders slack when data is valid", %{conn: conn, slack: %Slack{id: id} = slack} do
      conn = put conn, slack_path(conn, :update, slack), slack: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, slack_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, slack: slack} do
      conn = put conn, slack_path(conn, :update, slack), slack: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete slack" do
    setup [:create_slack]

    test "deletes chosen slack", %{conn: conn, slack: slack} do
      conn = delete conn, slack_path(conn, :delete, slack)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, slack_path(conn, :show, slack)
      end
    end
  end

  defp create_slack(_) do
    slack = fixture(:slack)
    {:ok, slack: slack}
  end
end
