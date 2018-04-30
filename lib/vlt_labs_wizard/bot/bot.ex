defmodule VltLabsWizard.Bot do
  @moduledoc """
  The Bot context.
  """

  use Slack
  import Ecto.Query, warn: false
  alias VltLabsWizard.Repo

  def manday_project_selection(emp = %{slack: "@" <> u_slack}) do
    user = Slack.Web.Users.list()["members"]
    |> Enum.find &(&1["name"] == u_slack)

    ac_channel = Slack.Web.Im.list["ims"]
    |> Enum.find &(&1["user"] == user["id"])

    Slack.Web.Chat.post_message(
      ac_channel["id"],
      "Which projects do you want to track man days for?",
      project_options(emp)
    )
  end
  def manday_project_selection(emp, slack) do
     Slack.Web.Chat.post_message(
      Slack.Lookups.lookup_direct_message_id(emp.slack, slack),
      # ^ returns channel not found for users who arent me :|
      # emp.slack,
      "Which projects do you want to track man days for?",
      project_options(emp)
    )
  end

  def projects_for(emp) do
    VltLabsWizard.Repo.preload(emp, :projects).projects
  end

  def features_for(emp, pr_id) do
    VltLabsWizard.Projects.get_project!(pr_id).features
  end

  def feature_options(emp, pr_id) do
    %{
      attachments:
      [
        %{
          text: "Which feature did you work on?",
          fallback: "No features...",
          callback_id: "select_days",
          attachment_type: "default",
          actions: Enum.map(
            features_for(emp, pr_id), &(
              %{
                name: &1.name,
                text: &1.name,
                type: "button",
                value: "project_id:#{pr_id};feature_id:#{&1.id}"
              })
          ) ++ [%{name: "No feature", text: "No feature", type: "button", value: "project_id:#{pr_id}"}]
        }
      ]
    }
  end

  def project_options(emp) do
    %{
      attachments:
      [
        %{
          text: "Choose project",
          fallback: "No projects...",
          callback_id: "select_feature",
          attachment_type: "default",
          actions: Enum.map(
            projects_for(emp), &(
              %{
                name: &1.name,
                text: &1.name,
                type: "button",
                value: &1.id
              }
            ))
        }
      ]
      |> Poison.encode!
    }
  end

  def remind_mandays do
    IO.puts "remind manday"
    query = from p in VltLabsWizard.HR.Employee,
      where: not is_nil(p.slack)

    emps = query
    |> Repo.all

    emps
    |> Enum.each(&(Slack.Web.Chat.post_message(&1.slack, "Hey, track your mandays!")))

    emps
    |> Enum.each(&(manday_project_selection(&1)))
  end

  @doc """
  Returns the list of slack.

  ## Examples

      iex> list_slack()
      [%Slack{}, ...]

  """
  def list_slack do
    raise "TODO"
  end

  @doc """
  Gets a single slack.

  Raises if the Slack does not exist.

  ## Examples

      iex> get_slack!(123)
      %Slack{}

  """
  def get_slack!(id), do: raise "TODO"

  @doc """
  Creates a slack.

  ## Examples

      iex> create_slack(%{field: value})
      {:ok, %Slack{}}

      iex> create_slack(%{field: bad_value})
      {:error, ...}

  """
  alias VltLabsWizard.Bot.SlackMessage
  def create_slack(attrs \\ %{}) do
    Slack.Web.Chat.post_message("#random", "test")
    {:ok, %SlackMessage{message: "sent", id: 1}}
  end

  @doc """
  Updates a slack.

  ## Examples

      iex> update_slack(slack, %{field: new_value})
      {:ok, %Slack{}}

      iex> update_slack(slack, %{field: bad_value})
      {:error, ...}

  """
  def update_slack(%{} = slack, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Slack.

  ## Examples

      iex> delete_slack(slack)
      {:ok, %Slack{}}

      iex> delete_slack(slack)
      {:error, ...}

  """
  def delete_slack(%{} = slack) do
    raise "TODO"
  end

  @doc """
  Returns a datastructure for tracking slack changes.

  ## Examples

      iex> change_slack(slack)
      %Todo{...}

  """
  def change_slack(%{} = slack) do
    raise "TODO"
  end
end
