defmodule VltLabsWizard.Web.SlackController do
  use VltLabsWizard.Web, :controller

  alias VltLabsWizard.Bot
  alias VltLabsWizard.Bot.SlackMessage

  action_fallback VltLabsWizard.Web.FallbackController

  def index(conn, _params) do
    slack = Bot.list_slack()
    render(conn, "index.json", slack: slack)
  end

  def day_options(project_id) do
    %{
      attachments:
      [
        %{
          text: "How many man days?",
          fallback: "No projects...",
          callback_id: "track_day",
          attachment_type: "default",
          actions: Enum.map(
            [1, 0.5, 0.25, 0.125], &(
              %{
                name: &1,
                text: &1,
                type: "button",
                value: "project_id:#{project_id};#{&1}"
              }
            ))
        }
      ]
    }
  end

  # selecting feature
  def handle_payload(
    conn,
    {:ok,
     payload =
       %{"actions" => [selected_action], "callback_id" => "select_feature"}}
  ) do
    employee =
      %{slack: "@#{payload["user"]["name"]}"}
      |> VltLabsWizard.HR.get_employee_by()
    conn
    |> json(
      %{
        text: "Selected project: #{selected_action["name"]}:",
      }
      |> Map.merge(Bot.feature_options(employee, selected_action["value"]))
    )
  end

  def handle_payload(
    conn,
    {:ok,
     payload =
      %{"actions" => [selected_action], "callback_id" => "select_days"}}
  ) do
    ["project_id:" <> pr_id] =
      String.split(selected_action["value"], ";")
    conn
    |> json(
      %{
        text: "Selected feature: #{selected_action["name"]}:",
        }
        |> Map.merge(day_options(pr_id))
    )
  end

  def save_project(["project_id:" <> pr_id, "feature_id:" <> f_id, value]) do

  end

  def save_project(employee, payload, ["project_id:" <> pr_id, value]) do
    alias VltLabsWizard.Projects
    {:ok, track} = Projects.create_man_day(%{
          employee_id: employee.id,
          project_id: pr_id,
          title: "From Slack",
          notes: "From Slack",
          performed_on: Date.utc_today, days: value}
    )
    project = Projects.get_project!(pr_id)
    new_total = Projects.calculate_man_days_for!(project)
    case track do
      nil -> "Oops, I couldn't track that"
      _ ->
        send :slack, {:set_state,
                      payload["user"]["id"],
                      %{input: :title, manday: track}}

        "Cool! Tracking #{value} days for #{project.name}.
        New total is #{new_total}.
        Please give a one sentence description of what you did:"
    end
  end

  def handle_payload(
    conn,
    {:ok, payload = %{"actions" => [selected_action],
                      "callback_id" => "track_day"}}
  ) do
    employee = VltLabsWizard.HR.get_employee_by(
      %{slack: "@#{payload["user"]["name"]}"}
    )

    pairs = String.split(
      selected_action["value"], ";"
    )

    response = save_project(employee, payload, pairs)

    conn
    |> json(
      %{
        text: response
      }
    )
  end

  def create(
    conn,
    %{"payload" => payload}
  ) do
    IO.inspect Poison.decode(payload)
    handle_payload(conn, Poison.decode(payload))
  end

  def create(conn, %{"slack" => slack_params}) do
    with {:ok, %SlackMessage{} = slack} <- Bot.create_slack(slack_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_slack_path(conn, :show, slack))
      |> render("show.json", slack: slack)
    end
  end

  def show(conn, %{"id" => id}) do
    slack = Bot.get_slack!(id)
    render(conn, "show.json", slack: slack)
  end

  def update(conn, %{"id" => id, "slack" => slack_params}) do
    slack = Bot.get_slack!(id)

    with {:ok, %{} = slack} <- Bot.update_slack(slack, slack_params) do
      render(conn, "show.json", slack: slack)
    end
  end

  def delete(conn, %{"id" => id}) do
    slack = Bot.get_slack!(id)
    with {:ok, %{}} <- Bot.delete_slack(slack) do
      send_resp(conn, :no_content, "")
    end
  end
end
