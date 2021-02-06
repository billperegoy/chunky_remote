defmodule ChunkyRemote.Email do
  @moduledoc """
  This moodule is used to build emails that are sent via the Bamboo
  mailer.
  """

  import Bamboo.Email

  def welcome_email(%{email: email, password: password}) do
    new_email(
      to: email,
      from: "support@example.com",
      subject: "Welcome to ChunkyRemote",
      text_body: "Your temporary password is #{password}"
    )
  end
end
