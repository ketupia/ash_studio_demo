defmodule AshStudioDemoWeb.Router do
  use AshStudioDemoWeb, :router

  use AshAuthentication.Phoenix.Router
  import AshAuthentication.Plug.Helpers
  import AshStudioWeb.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AshStudioDemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
    plug :set_actor, :user
  end

  scope "/", AshStudioDemoWeb do
    pipe_through :browser

    ash_authentication_live_session :authenticated_routes do
      # in each liveview, add one of the following at the top of the module:
      #
      # If an authenticated user must be present:
      # on_mount {AshStudioDemoWeb.LiveUserAuth, :live_user_required}
      #
      # If an authenticated user *may* be present:
      # on_mount {AshStudioDemoWeb.LiveUserAuth, :live_user_optional}
      #
      # If an authenticated user must *not* be present:
      # on_mount {AshStudioDemoWeb.LiveUserAuth, :live_no_user}

      live "/test", TestLive
    end
  end

  scope "/", Tunez do
    pipe_through :browser

    ash_authentication_live_session :tunez_authenticated_routes do
      live "/artists", Artists.IndexLive
      live "/artists/new", Artists.FormLive, :index
      live "/artists/:id", Artists.ShowLive, :index
      live "/artists/:id/edit", Artists.FormLive, :edit

      live "/artists/:artist_id/albums/new", Albums.FormLive, :new
      live "/albums/:id/edit", Albums.FormLive, :edit
    end
  end

  ash_studio_routes(path: "/studio", pipe_through: [:browser])

  scope "/", AshStudioDemoWeb do
    pipe_through :browser

    get "/", PageController, :home

    auth_routes AuthController, AshStudioDemo.Accounts.User, path: "/auth"
    sign_out_route AuthController

    # Remove these if you'd like to use your own authentication views
    sign_in_route register_path: "/register",
                  reset_path: "/reset",
                  auth_routes_prefix: "/auth",
                  on_mount: [{AshStudioDemoWeb.LiveUserAuth, :live_no_user}],
                  overrides: [
                    AshStudioDemoWeb.AuthOverrides,
                    AshAuthentication.Phoenix.Overrides.Default
                  ]

    # Remove this if you do not want to use the reset password feature
    reset_route auth_routes_prefix: "/auth",
                overrides: [
                  AshStudioDemoWeb.AuthOverrides,
                  AshAuthentication.Phoenix.Overrides.Default
                ]
  end

  # Other scopes may use custom stacks.
  # scope "/api", AshStudioDemoWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ash_studio_demo, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AshStudioDemoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  if Application.compile_env(:ash_studio_demo, :dev_routes) do
    import AshAdmin.Router

    scope "/admin" do
      pipe_through :browser

      ash_admin "/"
    end
  end
end
