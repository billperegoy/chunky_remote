defmodule ChunkyRemote.SampleTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query
  import ChunkyRemote.Factory

  describe "Login flow" do
    feature "Create user properly redirects", %{session: session} do
      session
      |> create_user("user-1", "user@example.com")
      |> find(css(".user", count: 1))
      |> assert_has(css(".username", count: 1, text: "user-1"))
      |> assert_has(css(".email", count: 1, text: "user@example.com"))
      |> assert_has(css(".status", count: 1, text: "unverified"))
    end

    feature "New user can verify their account", %{session: session} do
      session
      |> create_user("user-1", "user@example.com")
      |> verify_user("user-1", "random-password", "my-new-password")
      |> assert_has(css(".page-header", count: 1, text: "Remote Control Dashboard"))
    end

    feature "user can login", %{session: session} do
      insert(:user, username: "username")

      session
      |> login("username", "password")
      |> assert_has(css(".page-header", count: 1, text: "Remote Control Dashboard"))
    end

    feature "user logging in with bad passwored returns error", %{session: session} do
      insert(:user, username: "username")

      session
      |> login("username", "bad-password")
      |> assert_has(css(".alert-danger", count: 1, text: "Login Failed"))
    end
  end

  defp create_user(session, username, email) do
    session
    |> visit("/users/new")
    |> fill_in(text_field("User Name"), with: username)
    |> fill_in(text_field("Email"), with: email)
    |> click(button("Create User"))
  end

  defp verify_user(session, username, old_password, new_password) do
    session
    |> visit("/users/verify/new")
    |> fill_in(text_field("User Name"), with: username)
    |> fill_in(text_field("Temporary Password"), with: old_password)
    |> fill_in(text_field("New Password"), with: new_password)
    |> click(button("Verify User"))
  end

  defp login(session, username, password) do
    session
    |> visit("/login/new")
    |> fill_in(text_field("User Name"), with: username)
    |> fill_in(text_field("Password"), with: password)
    |> click(button("Login"))
  end
end
