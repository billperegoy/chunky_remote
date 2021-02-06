defmodule ChunkyRemote.Account.Permission do
  @moduledoc """
  Schema and changeset for Permission
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type result :: {:ok, t} | {:ok, Ecto.Changeset.t()}

  schema "permissions" do
    field(:name, :string)
    timestamps(type: :utc_datetime_usec)
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(permission, attrs) do
    required_attrs = [:name]

    permission
    |> cast(attrs, required_attrs)
    |> validate_required(required_attrs)
  end
end
