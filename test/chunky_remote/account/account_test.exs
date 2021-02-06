defmodule ChunkyRemote.AccountTest do
  use ChunkyRemote.DataCase

  alias ChunkyRemote.{Account, Email}

  describe "user" do
    test "create" do
      attrs = %{"username" => "mark-arm", "email" => "mark@exammple.com"}
      {:ok, user} = Account.create_user(attrs)

      assert_maps_equal(
        user,
        %{username: attrs["username"], email: attrs["email"], status: :unverified},
        [:username, :email, :status]
      )

      expected_email = Email.welcome_email(%{email: attrs["email"], password: "random-password"})
      assert_delivered_email(expected_email)
    end

    test "verify with correct old password" do
      attrs = %{"username" => "mark-arm", "email" => "mark@exammple.com"}
      {:ok, user} = Account.create_user(attrs)

      {:ok, updated_user} =
        Account.verify_user(user, %{old_password: "random-password", password: "new-password"})

      assert updated_user.status == :confirmed
    end

    test "verify with incorrect old password" do
      attrs = %{"username" => "mark-arm", "email" => "mark@exammple.com"}
      {:ok, user} = Account.create_user(attrs)

      {:error, error} =
        Account.verify_user(user, %{old_password: "bad-password", password: "new-password"})

      assert error == "invalid password"

      {:ok, fetched_user} = Account.get_user(user.id)
      assert fetched_user.status == :unverified
      assert user.updated_at == fetched_user.updated_at
    end
  end
end
