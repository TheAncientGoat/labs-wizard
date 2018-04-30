defmodule VltLabsWizard.Bot.SlackRtm do
  @moduledoc "Slack command wrappers"
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def find_session(message = %{user: user}, state) do
    state[String.to_atom(user)]
  end

  def handle_event(message, slack, state)
  def handle_event(
    message = %{type: "message", text: rest}, slack,
    state = [:employee_id, emp_id, :tracking, :mandays]) do

    send_message("ID of project to track " <> rest <> " days for?",
      message.channel, slack)
    {:ok, [:days, rest] ++ state}
  end
  def handle_event(
    message = %{type: "message", text: rest}, slack,
    state = [:days, days, :employee_id, emp_id, :tracking, :mandays]) do

    proj = VltLabsWizard.Projects.create_man_day(
      %{days: days, project_id: rest, employee_id: emp_id,
        performed_on: Date.utc_today, notes: "From bot", title: "day from bot"})
    days = VltLabsWizard.Projects.calculate_man_days_for!(
      VltLabsWizard.Projects.get_project!(rest))
    send_message("Tracked! New total: " <> Decimal.to_string(days),
      message.channel, slack)
    {:ok, state}
  end
  def handle_event(
    message = %{type: "message", text: "<@U6HDV9SEL>" <> rest},
    slack, state),
    do: send_reply(message, slack, state)

  def handle_event(
    message = %{type: "message", channel: _, user: user},
    slack, state
  ) do
    case slack.me do
      %{id: ^user} ->
        IO.puts "Don't message yourself, silly"
        {:ok, state}
      _ ->
        session = find_session(message, state)
        state =
          case session do
            nil -> state ++ [{String.to_atom(user), []}]
            _ -> state
          end

        {:ok, res} =
          handle_session(message, slack, load_session(user, slack, state))
        Access.get_and_update(
          state, String.to_atom(user), fn(a) -> {:ok, res} end)
    end
  end

  def load_session(user, slack, state) do
    state = Enum.into(find_session(%{user: user}, state), %{})
    employee = fn () ->
      VltLabsWizard.HR.get_employee_by(
        %{slack: Slack.Lookups.lookup_user_name(user, slack)}
      )
    end
    case state[:employee] do
      nil -> Enum.into([employee: employee.()], state)
      _ -> state
    end
  end


  @unknown_user """
    Hmm, I don't know you. Please check that you have registered on Labs Wizard
    and have set your Slack username
  """

  def handle_session(message, slack, state)

  # Handle employee not found
  def handle_session(message, slack, state = %{employee: nil}) do
    send_message(@unknown_user, message.channel, slack)
    {:ok, state}
  end


  # Update employee's manday notes
  def handle_session(
    message = %{text: "notes:" <> notes},
    slack, state = %{input: :notes, manday: manday, employee: emp}
  ) do
    res = VltLabsWizard.Projects.update_man_day(manday, %{notes: notes})
    text =
      case res do
        {:ok, _} -> "Woohoo, specifics!
        Updated your manday notes for #{manday.title}"
        _ -> "Oops, something went wrong..."
      end
    send_message(
      text,
      message.channel,
      slack)
    {:ok, %{state | input: nil}}
  end

  # Update employee's manday title
  def handle_session(
    message = %{text: title},
    slack, state = %{input: :title, manday: manday, employee: emp}
  ) do
    res = VltLabsWizard.Projects.update_man_day(manday, %{title: title})
    text =
      case res do
        {:ok, _} -> "Great, I've added the description.
        If you want, you can say 'notes: (and put your notes)'
        to add further details to your latest tracked day. See you tomorrow!"
        _ -> "Oops, something went wrong..."
    end
    send_message(
      text,
      message.channel,
      slack)
    {:ok, %{state | input: :notes}}
  end

  # Show projects for employee
  def handle_session(
    message = %{text: "projects"},
    slack, state = %{employee: emp}
  ) do
    send_message("You are currently assigned to: " <>
      Enum.join(Enum.map(VltLabsWizard.Bot.projects_for(emp), &(&1.name)), ", "),
      message.channel,
      slack)
    {:ok, state}
  end

  # Track manday
  def handle_session(
    message = %{text: "track manday" <> rest},
    slack,
    state = %{employee: emp}
  ) do
    send_message(
      "Lets track mandays!",
      message.channel,
      slack)
    VltLabsWizard.Bot.manday_project_selection(emp, slack)
    {:ok, state}
  end

  def handle_session(message, slack, state = %{employee: emp}) do
    send_message("Sorry #{emp.nickname}, I only track man days at the moment...
    (say 'track manday' or 'projects' to start)", message.channel, slack)
    {:ok, state}
  end

  def send_reply(message, slack, state) do
    send_message("Did you track your mandays, " <>
      Slack.Lookups.lookup_user_name(message.user, slack) <> "?",
      message.channel, slack)
    {:ok, state}
  end

  def send_manday_reply(message, rest, slack, state) do
    employee = VltLabsWizard.HR.get_employee_by(%{nickname: rest})
    send_message("How many days for " <> employee.nickname <> "?",
      message.channel, slack)
    {:ok, [:employee_id, employee.id, :tracking, :mandays]}
  end

  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:set_state, user, update}, slack, state) do
    res = Map.merge(find_session(%{user: user}, state), update)

    Access.get_and_update(state, String.to_atom(user), fn(a) -> {:ok, res} end)
  end

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"
    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
