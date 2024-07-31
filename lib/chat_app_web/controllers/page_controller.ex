defmodule ChatAppWeb.PageController do
  use ChatAppWeb, :controller

  alias ChatApp.Chats

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    chats = Chats.list_chats()

    messages =
      if chats != [] do
        chats |> List.first() |> Chats.list_messages_for_chat()
      else
        []
      end

    user_token = get_session(conn, :user_token) |> Base.url_encode64(padding: false)

    render(conn, :home, layout: false, chats: chats, chat: chats |> List.first(), messages: messages, user_token: user_token)
  end

  def chat(conn, %{"id" => chat_id}) do
    # The home page is often custom made,
    # so skip the default app layout.

    chats = Chats.list_chats()

    chat = Chats.get_chat!(chat_id)
    messages = chat |> Chats.list_messages_for_chat()

    user_token = get_session(conn, :user_token) |> Base.url_encode64(padding: false)

    render(conn, :home, layout: false, chats: chats, chat: chat, messages: messages, user_token: user_token)
  end
end
