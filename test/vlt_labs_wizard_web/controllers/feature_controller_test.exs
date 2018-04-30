defmodule VltLabsWizardWeb.FeatureControllerTest do
  use VltLabsWizardWeb.ConnCase

  alias VltLabsWizard.Projects
  alias VltLabsWizard.Projects.Feature

  @create_attrs %{end_on: ~D[2010-04-17], estimated_days: "120.5", name: "some name", notes: "some notes", start_on: ~D[2010-04-17]}
  @update_attrs %{end_on: ~D[2011-05-18], estimated_days: "456.7", name: "some updated name", notes: "some updated notes", start_on: ~D[2011-05-18]}
  @invalid_attrs %{end_on: nil, estimated_days: nil, name: nil, notes: nil, start_on: nil}

  def fixture(:feature) do
    {:ok, feature} = Projects.create_feature(@create_attrs)
    feature
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all features", %{conn: conn} do
      conn = get conn, feature_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create feature" do
    test "renders feature when data is valid", %{conn: conn} do
      conn = post conn, feature_path(conn, :create), feature: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, feature_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "end_on" => ~D[2010-04-17],
        "estimated_days" => "120.5",
        "name" => "some name",
        "notes" => "some notes",
        "start_on" => ~D[2010-04-17]}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, feature_path(conn, :create), feature: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update feature" do
    setup [:create_feature]

    test "renders feature when data is valid", %{conn: conn, feature: %Feature{id: id} = feature} do
      conn = put conn, feature_path(conn, :update, feature), feature: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, feature_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "end_on" => ~D[2011-05-18],
        "estimated_days" => "456.7",
        "name" => "some updated name",
        "notes" => "some updated notes",
        "start_on" => ~D[2011-05-18]}
    end

    test "renders errors when data is invalid", %{conn: conn, feature: feature} do
      conn = put conn, feature_path(conn, :update, feature), feature: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete feature" do
    setup [:create_feature]

    test "deletes chosen feature", %{conn: conn, feature: feature} do
      conn = delete conn, feature_path(conn, :delete, feature)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, feature_path(conn, :show, feature)
      end
    end
  end

  defp create_feature(_) do
    feature = fixture(:feature)
    {:ok, feature: feature}
  end
end
