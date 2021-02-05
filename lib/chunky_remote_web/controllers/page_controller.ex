defmodule ChunkyRemoteWeb.PageController do
  use ChunkyRemoteWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
