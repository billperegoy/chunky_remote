defmodule ChunkyRemote.Repo do
  use Ecto.Repo,
    otp_app: :chunky_remote,
    adapter: Ecto.Adapters.Postgres
end
