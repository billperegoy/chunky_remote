defmodule ChunkyRemoteWeb.Router do
  use ChunkyRemoteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChunkyRemoteWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create, :index]
    get "/users/verify_new", UserController, :verify_new
    post "/users/verify", UserController, :verify
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChunkyRemoteWeb do
  #   pipe_through :api
  # end
end
