defmodule ChunkyRemote.Account.User do
  @moduledoc """
  Schema and changeset for User.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type result :: {:ok, t} | {:ok, Ecto.Changeset.t()}

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:status, Ecto.Enum, values: [:unverified, :confirmed], default: :unverified)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    timestamps(type: :utc_datetime_usec)
  end

  @spec create_changeset(t, map) :: Ecto.Changeset.t()
  def create_changeset(user, attrs) do
    required_attrs = [:username, :email, :password_hash]

    user
    |> cast(attrs, required_attrs)
    |> validate_required(required_attrs)
  end

  @spec verify_changeset(t, map) :: Ecto.Changeset.t()
  def verify_changeset(user, attrs) do
    required_attrs = [:password_hash]

    user
    |> cast(attrs, required_attrs)
    |> validate_required(required_attrs)
    |> force_change(:status, :confirmed)
  end
end
