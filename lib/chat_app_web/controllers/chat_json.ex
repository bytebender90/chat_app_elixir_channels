defmodule ChatAppWeb.ChatJSON do
  alias ChatApp.Chats.Chat
  alias ChatApp.Chats.Message

  @doc """
  Renders a list of chats.
  """
  def index(%{chats: chats}) do
    %{data: for(chat <- chats, do: data(chat))}
  end

  @doc """
  Renders a single chat.
  """
  def show(%{chat: chat}) do
    %{data: data(chat)}
  end

  defp data(%Chat{messages: messages} = chat) when is_list(messages) do
    %{
      id: chat.id,
      name: chat.name,
      messages: for(message <- messages, do: data(message))
    }
  end

  defp data(%Chat{} = chat) do
    %{
      id: chat.id,
      name: chat.name
    }
  end

  defp data(%Message{} = message) do
    %{
      id: message.id,
      content: message.content,
      timestamp: message.inserted_at,
      sender_id: message.sender_id
    }
  end
end
