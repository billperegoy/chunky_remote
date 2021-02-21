defmodule ChunkyRemoteWeb.Router do
  use ChunkyRemoteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ChunkyRemoteWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChunkyRemoteWeb do
    pipe_through :browser

    get "/", LoginController, :new
    resources "/login", LoginController, only: [:new, :create]
    resources "/users", UserController, only: [:new, :create, :index]
    resources "/users/verify", VerifyController, only: [:new, :create]
    resources "/dashboard", DashboardController, only: [:index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChunkyRemoteWeb do
  #   pipe_through :api
  # end
end
