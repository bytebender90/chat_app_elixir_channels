defmodule ChatAppWeb.ChatController do
  use ChatAppWeb, :controller

  alias ChatApp.Chats
  alias ChatApp.Chats.Chat

  action_fallback ChatAppWeb.FallbackController

  def index(conn, _params) do
    chats = Chats.list_chats()
    render(conn, :index, chats: chats)
  end

  def create(conn, %{"chat" => chat_params}) do
    with {:ok, %Chat{} = chat} <- Chats.create_chat(chat_params) do
      conn
      |> put_status(:created)
      |> render(:show, chat: chat)
    end
  end

  def show(conn, %{"id" => id}) do
    chat = Chats.get_chat!(id)

    # Implement Pagination here
    messages = Chats.list_messages_for_chat(chat)

    render(conn, :show, chat: Map.put(chat, :messages, messages))
  end

  # def update(conn, %{"id" => id, "chat" => chat_params}) do
  #   chat = Chats.get_chat!(id)

  #   with {:ok, %Chat{} = chat} <- Chats.update_chat(chat, chat_params) do
  #     render(conn, :show, chat: chat)
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    chat = Chats.get_chat!(id)

    with {:ok, %Chat{}} <- Chats.delete_chat(chat) do
      send_resp(conn, :no_content, "")
    end
  end
end
