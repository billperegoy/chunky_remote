defmodule ChunkyRemote.Factory do
  @moduledoc """
  Test fixtures for project.
  """

  use ExMachina.Ecto, repo: ChunkyRemote.Repo
  alias ChunkyRemote.Account

  def user_factory do
    %Account.User{
      username: sequence(:username, &"user-#{&1}"),
      email: sequence(:email, &"user_#{&1}.example.com"),
      password_hash: Account.hash_password("password")
    }
  end

  def permission_factory do
    %Account.Permission{
      name: sequence(:name, &"permission-#{&1}")
    }
  end
end
