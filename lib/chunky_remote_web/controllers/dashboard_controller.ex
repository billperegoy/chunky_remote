defmodule ChunkyRemoteWeb.DashboardController do
  use ChunkyRemoteWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
