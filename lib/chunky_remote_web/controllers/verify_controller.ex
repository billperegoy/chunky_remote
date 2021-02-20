defmodule ChunkyRemoteWeb.VerifyController do
  use ChunkyRemoteWeb, :controller
  alias ChunkyRemote.{Account, Account.User}

  def new(conn, _params) do
    render(conn, "new.html", changeset: User.verify_changeset(%User{}, %{}))
  end

  def create(conn, %{
        "user" => %{
          "username" => username,
          "password" => password,
          "new_password" => new_password
        }
      }) do
    with {:ok, user} <- Account.get_user_by_username(username) do
      Account.verify_user(user, %{old_password: password, password: new_password})

      conn
      |> put_flash(:info, "Verified user: #{user.username}")
      |> redirect(to: Routes.user_path(conn, :index))
    end
  end
end
