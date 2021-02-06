defmodule ChunkyRemote.Repo.Migrations.AddUserAndPermission do
  use Ecto.Migration

  def change do
    create table("users") do
      add(:username, :string, null: false)
      add(:email, :string, null: false)
      add(:status, :string, null: false, default: "unverified")
      add(:password_hash, :string)

      timestamps(type: :utc_datetime_usec)
    end

    create table("permissions") do
      add(:name, :string, null: false)

      timestamps(type: :utc_datetime_usec)
    end

    create table("users_permissions") do
      add(:user_id, references("users"), null: false)
      add(:permission_id, references("permissions"), null: false)

      timestamps(type: :utc_datetime_usec)
    end
  end
end
