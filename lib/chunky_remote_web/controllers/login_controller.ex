defmodule ChunkyRemoteWeb.LoginController do
  use ChunkyRemoteWeb, :controller

  alias ChunkyRemote.{Account, Account.User}

  def new(conn, _params) do
    render(conn, "new.html", changeset: User.create_changeset(%User{}, %{}))
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    with {:ok, user} <- Account.get_user_by_username(username),
         {:ok, _} <- Argon2.check_pass(user, password) do
      conn
      |> assign(:current_user, user)
      |> put_session(:user_id, user.id)
      |> redirect(to: Routes.dashboard_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:error, "Login Failed")
        |> redirect(to: Routes.login_path(conn, :new))
    end
  end
end
