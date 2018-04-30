defmodule VltLabsWizard.Factory do
  @moduledoc """
  Factories, mainly for associations
  """
  # with Ecto
  use ExMachina.Ecto, repo: VltLabsWizard.Repo

  def department_factory do
    %VltLabsWizard.HR.Department{
      name: "some department"
    }
  end

  def user_factory do
    %VltLabsWizard.Auth.User{
      email: "some email", username: "some username",
      last_login_at: ~D[2010-04-17], login_count: 42, password: "some password"
    }
  end

  def employee_factory do
    %VltLabsWizard.HR.Employee{
      avatar: "some avatar", email: "some email", first_name: "some first_name",
      last_name: "some last_name", mobile: "some mobile",
      nickname: "some nickname", title: "some title",
      department: build(:department)
    }
  end

  def project_factory do
    %VltLabsWizard.Projects.Project{
      description: "some description", estimated_man_days: "120.5",
      manday_cost: "120.5", max_manday: 2, min_manday: 2, name: "some name",
      priority: 2, production_url: "some production_url",
      staging_url: "some staging_url", status: 2
    }
  end

  def man_day_factory do
    %VltLabsWizard.Projects.ManDay{
      title: "a test manday",
      days: "120.5", notes: "some notes",
      performed_on: ~D[2010-04-17],
      employee: build(:employee),
      project: build(:project)}
  end
#   def user_factory do
#     %MyApp.User{
#       name: "Jane Smith",
#       email: sequence(:email, &"email-#{&1}@example.com"),
#     }
#   end

#   def article_factory do
#     %MyApp.Article{
#       title: "Use ExMachina!",
#       # associations are inserted when you call `insert`
#       author: build(:user),
#     }
#   end

#   def comment_factory do
#     %MyApp.Comment{
#       text: "It's great!",
#       article: build(:article),
#     }
#   end
end
