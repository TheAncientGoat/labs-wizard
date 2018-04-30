defmodule VltLabsWizard.Bot.SlackScheduler do
  @moduledoc "handles bot jobs"
  use Quantum.Scheduler,
    otp_app: :vlt_labs_wizard
end
