defmodule ChunkyRemote.Notifier do
  @moduledoc """
  This module coctains callback functions used by the event_bus
  package.
  """

  alias ChunkyRemote.{Account, Email, Mailer}

  def process({:user_created, id} = event_shadow) do
    event = EventBus.fetch_event({:user_created, id})

    {:ok, user} = Account.get_user(event.data.user_id)

    IO.puts(
      "Sending email notification to: #{user.email} with password: #{
        event.data.temporary_password
      }"
    )

    %{email: user.email, password: event.data.temporary_password}
    |> Email.welcome_email()
    |> Mailer.deliver_now()

    :ok = EventBus.mark_as_completed({ChunkyRemote.Notifier, event_shadow})
  end
end
