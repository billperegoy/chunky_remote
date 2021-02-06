defmodule ChunkyRemoteWeb.UserController do
  use ChunkyRemoteWeb, :controller
  alias ChunkyRemote.{Account, Account.User}

  def new(conn, _params) do
    render(conn, "new.html", changeset: User.create_changeset(%User{}, %{}))
  end

  def create(conn, %{"user" => user_params}) do
    {:ok, user} = Account.create_user(user_params)

    conn
    |> put_flash(:info, "Created user: #{user.username}")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  def index(conn, _params) do
    users = Account.list_users()

    render(conn, "index.html", users: users)
  end

  def verify_new(conn, _params) do
    render(conn, "verify_new.html", changeset: User.verify_changeset(%User{}, %{}))
  end

  def verify(conn, %{
        "user" => %{
          "username" => username,
          "password" => password,
          "new_password" => new_password
        }
      }) do
    {:ok, user} = Account.get_user_by_username(username)

    Account.verify_user(user, %{old_password: password, password: new_password})

    conn
    |> put_flash(:info, "Verified user: {user.username}")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
