defmodule ChunkyRemote.SampleTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  describe "Login flow" do
    test "Create user properly redirects", %{session: session} do
      session
      |> create_user
      |> find(css(".user", count: 1))
      |> assert_has(css(".username", count: 1, text: "user-1"))
      |> assert_has(css(".email", count: 1, text: "user@example.com"))
      |> assert_has(css(".status", count: 1, text: "unverified"))
    end

    test "New user can verify their account", %{session: session} do
      session
      |> create_user
      |> visit("/users/verify_new")
      |> fill_in(text_field("User Name"), with: "user-1")
      |> fill_in(text_field("Temporary Password"), with: "random-password")
      |> fill_in(text_field("New Password"), with: "my-new-password")
      |> take_screenshot
      |> click(button("Verify User"))
      |> take_screenshot
      |> find(css(".user", count: 1))
      |> assert_has(css(".username", count: 1, text: "user-1"))
      |> assert_has(css(".status", count: 1, text: "confirmed"))
    end
  end

  def create_user(session) do
    session
    |> visit("/users/new")
    |> fill_in(text_field("User Name"), with: "user-1")
    |> fill_in(text_field("Email"), with: "user@example.com")
    |> click(button("Create User"))
  end
end
