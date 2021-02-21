defmodule ChunkyRemoteWeb.Auth do
  import Plug.Conn

  alias ChunkyRemote.Account

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    if user_id do
      user_id
      |> Account.get_user()
      |> case do
        {:ok, user} ->
          assign(conn, :current_user, user)

        {:error, _} ->
          conn
      end
    else
      conn
    end
  end
end
