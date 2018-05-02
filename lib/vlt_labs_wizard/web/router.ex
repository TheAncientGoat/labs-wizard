defmodule VltLabsWizard.Web.Router do
  use VltLabsWizard.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["html", "json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
    plug VltLabsWizard.Auth.CurrentUser
  end

  pipeline :api_login_required do
    plug Guardian.Plug.EnsureAuthenticated,
      handler: VltLabsWizard.Auth.GuardianApiErrorHandler
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated,
      handler: VltLabsWizard.Auth.GaurdianErrorHandler
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug VltLabsWizard.Auth.CurrentUser
  end

  # guests
  scope "/", VltLabsWizard.Web do
    pipe_through [:browser, :with_session] # Use the default browser stack

    get "/", PageController, :index
    resources "/sessions", SessionController
    resources "/users", UserController

    scope "/" do
      pipe_through [:login_required]
      get "/sign-out", SessionController, :delete
      resources "/employees", EmployeeController
      resources "/projects", ProjectController
      resources "/assignments", AssignmentController
      resources "/man_days", ManDayController
    end
  end

  # Other scopes may use custom stacks.
  scope "/api", VltLabsWizard.Web, as: :api do
    pipe_through :api
    resources "/features", FeatureController
    resources "/avatar", AvatarApiController
    resources "/employees", EmployeeApiController, except: [:new, :edit]
    resources "/departments", DepartmentController, except: [:new, :edit]
    resources "/slack", SlackController, except: [:new, :edit]
    resources "/man_day_purchase", ManDayPurchaseController, except: [:new, :edit]
  end

  scope "/api", VltLabsWizard.Web.API, as: :api do
    pipe_through [:api]
    resources "/auth", AuthController, except: [:new, :edit]
    resources "/users", UsersController, except: [:new, :edit]

    scope "/" do
      pipe_through [:api_login_required]
      resources "/projects", ProjectController, except: [:new, :edit]
      resources "/assignments", AssignmentController, except: [:new, :edit]
      resources "/man_days", ManDayController
    end
  end

  use ExAdmin.Router
  # your app's routes
  scope "/admin", ExAdmin do
    pipe_through([:browser, :with_session, :login_required])
    admin_routes()
  end
end
