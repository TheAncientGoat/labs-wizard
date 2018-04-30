defmodule VltLabsWizard.Web.FeatureController do
  use VltLabsWizard.Web, :controller

  alias VltLabsWizard.Projects
  alias VltLabsWizard.Projects.Feature

  action_fallback VltLabsWizard.Web.FallbackController

  def index(conn, _params) do
    features = Projects.list_features()
    render(conn, "index.json", features: features)
  end

  def create(conn, %{"feature" => feature_params}) do
    with {:ok, %Feature{} = feature} <- Projects.create_feature(feature_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_feature_path(conn, :show, feature))
      |> render("show.json", feature: feature)
    end
  end

  def show(conn, %{"id" => id}) do
    feature = Projects.get_feature!(id)
    render(conn, "show.json", feature: feature)
  end

  def update(conn, %{"id" => id, "feature" => feature_params}) do
    feature = Projects.get_feature!(id)

    with {:ok, %Feature{} = feature} <- Projects.update_feature(feature, feature_params) do
      render(conn, "show.json", feature: feature)
    end
  end

  def delete(conn, %{"id" => id}) do
    feature = Projects.get_feature!(id)
    with {:ok, %Feature{}} <- Projects.delete_feature(feature) do
      send_resp(conn, :no_content, "")
    end
  end
end
