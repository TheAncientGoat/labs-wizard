defmodule VltLabsWizard.Web.FeatureView do
  use VltLabsWizard.Web, :view
  alias VltLabsWizard.Web.FeatureView

  def render("index.json", %{features: features}) do
    %{data: render_many(features, FeatureView, "feature.json")}
  end

  def render("show.json", %{feature: feature}) do
    %{data: render_one(feature, FeatureView, "feature.json")}
  end

  def render("feature.json", %{feature: feature}) do
    %{id: feature.id,
      name: feature.name,
      estimated_days: feature.estimated_days,
      start_on: feature.start_on,
      end_on: feature.end_on,
      notes: feature.notes}
  end
end
