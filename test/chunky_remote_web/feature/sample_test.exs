defmodule ChunkyRemote.SampleTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  feature "users have names", %{session: session} do
    session
    |> visit("/")
    |> assert_has(Query.css("#page"))
  end
end
