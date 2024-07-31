defmodule ChatAppWeb.ChatChannel do
  use ChatAppWeb, :channel

  alias ChatApp.Chats

  @impl true
  def join("chat:" <> chat_id, _payload, socket) do
    {:ok, assign(socket, chat_id: chat_id)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat_channel:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in(
        "new_message",
        %{"message" => content} = message,
        %{assigns: %{current_user: current_user, chat_id: chat_id}} = socket
      ) do
    case Chats.create_message(
           current_user,
           Chats.get_chat!(chat_id),
           %{content: content}
         ) do
      {:ok, message} ->
        broadcast!(socket, "chat:#{chat_id}:added_new_msg", %{
          inserted_at: message.inserted_at,
          content: message.content,
          sender_id: message.sender_id
        })

      {:error, _message} ->
        broadcast!(socket, "chat:#{chat_id}:error_msg", message)
    end

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
