defmodule ChunkyRemote.Account do
  @moduledoc """
  Functions to manipuate Account entities.
  """
  import Ecto.Query, warn: false
  alias ChunkyRemote.{Account, Account.User, Repo}

  @words_in_password 3

  @spec get_user(non_neg_integer) :: User.result()
  def get_user(id) do
    User
    |> Repo.get(id)
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def get_user_by_username(username) do
    from(u in User, where: u.username == ^username)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  @spec list_users :: [User.t()]
  def list_users do
    Repo.all(User)
  end

  @typep create_user_attrs :: %{required(:username) => String.t(), required(:email) => String.t()}

  @spec create_user(create_user_attrs) :: Account.User.result()
  def create_user(attrs) do
    password = random_password()

    attrs = Map.put(attrs, "password_hash", hash_password(password))

    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
    |> notify(password)
  end

  def hash_password(password) do
    password
    |> Argon2.add_hash()
    |> Map.get(:password_hash)
  end

  defp notify({:ok, user} = result, password) do
    event = %EventBus.Model.Event{
      id: Ecto.UUID.generate(),
      topic: :user_created,
      data: %{user_id: user.id, temporary_password: password}
    }

    EventBus.notify(event)

    result
  end

  defp notify(error, _password) do
    error
  end

  @typep verify_user_attrs :: %{
           required(:old_password) => String.t(),
           required(:password) => String.t()
         }
  @spec verify_user(User.t(), verify_user_attrs) :: Account.User.result()
  def verify_user(user, %{old_password: old_password, password: password} = attrs) do
    with {:ok, _} <- Argon2.check_pass(user, old_password) do
      attrs = Map.merge(attrs, Argon2.add_hash(password))

      user
      |> User.verify_changeset(attrs)
      |> Repo.update()
    end
  end

  defp random_password(length \\ @words_in_password) do
    if Mix.env() == :test do
      "random-password"
    else
      random_password(Faker.Person.first_name(), length - 1)
    end
  end

  defp random_password(password, 0) do
    password
  end

  defp random_password(password, length) do
    random_password("#{password}-#{Faker.Person.first_name()}", length - 1)
  end
end
