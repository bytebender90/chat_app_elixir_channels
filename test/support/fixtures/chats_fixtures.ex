defmodule ChatApp.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChatApp.Chats` context.
  """

  @doc """
  Generate a chat.
  """
  def chat_fixture(attrs \\ %{}) do
    {:ok, chat} =
      attrs
      |> Enum.into(%{
        name: "some name",
        user_ids: [
          ChatApp.AccountsFixtures.user_fixture()
          |> Map.get(:id)
          |> Integer.to_string()
        ]
      })
      |> ChatApp.Chats.create_chat()

    chat
  end

  @doc """
  Generate a messages.
  """

  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      ChatApp.Chats.create_message(
        Map.get(attrs, :user, nil) || ChatApp.AccountsFixtures.user_fixture(),
        Map.get(attrs, :chat, nil) || chat_fixture(),
        attrs
        |> Map.drop([:user, :chat])
        |> Enum.into(%{
          content: "my message"
        })
      )

    message
  end
end
