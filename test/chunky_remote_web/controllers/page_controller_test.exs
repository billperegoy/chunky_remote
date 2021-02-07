defmodule ChunkyRemoteWeb.PageControllerTest do
  use ChunkyRemoteWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Chunky Kong Remote Control"
  end
end
