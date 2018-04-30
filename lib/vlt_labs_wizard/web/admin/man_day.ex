defmodule VltLabsWizard.ExAdmin.ManDay do
  use ExAdmin.Register

  register_resource VltLabsWizard.Projects.ManDay do
    form manday do
      inputs do

        %{year: year, month: month, day: day} = Date.utc_today
        input manday, :title
        input manday, :notes, type: :text
        input manday, :days, type: :number
        input manday, :performed_on,
          options: [
            year: [value: year, options: 2015 .. (year + 1)],
            month: [value: month],
            day: [value: day]
          ]

        input manday, :project,
          collection: VltLabsWizard.Repo.all(VltLabsWizard.Projects.Project)
        input manday, :employee,
          collection: VltLabsWizard.Repo.all(VltLabsWizard.HR.Employee)
        input manday, :feature,
          collection: VltLabsWizard.Repo.all(VltLabsWizard.Projects.Feature)
      end
    end
  end
end
