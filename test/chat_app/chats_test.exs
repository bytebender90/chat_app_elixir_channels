defmodule ChatApp.ChatsTest do
  use ChatApp.DataCase

  alias ChatApp.Chats

  describe "chats" do
    alias ChatApp.Chats.Chat

    import ChatApp.ChatsFixtures

    @invalid_attrs %{name: nil}

    test "list_chats/0 returns all chats" do
      chat = chat_fixture()
      assert Chats.list_chats() == [chat]
    end

    test "get_chat!/1 returns the chat with given id" do
      chat = chat_fixture()
      assert Chats.get_chat!(chat.id) == chat
    end

    test "create_chat/1 with valid data creates a chat" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Chat{} = chat} = Chats.create_chat(valid_attrs)
      assert chat.name == "some name"
    end

    test "create_chat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_chat(@invalid_attrs)
    end

    test "update_chat/2 with valid data updates the chat" do
      chat = chat_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Chat{} = chat} = Chats.update_chat(chat, update_attrs)
      assert chat.name == "some updated name"
    end

    test "update_chat/2 with invalid data returns error changeset" do
      chat = chat_fixture()
      assert {:error, %Ecto.Changeset{}} = Chats.update_chat(chat, @invalid_attrs)
      assert chat == Chats.get_chat!(chat.id)
    end

    test "delete_chat/1 deletes the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{}} = Chats.delete_chat(chat)
      assert_raise Ecto.NoResultsError, fn -> Chats.get_chat!(chat.id) end
    end

    test "change_chat/1 returns a chat changeset" do
      chat = chat_fixture()
      assert %Ecto.Changeset{} = Chats.change_chat(chat)
    end

    test "list_messages_for_chat/1 returns all messages for a given chat" do
      chat = chat_fixture()
      message = message_fixture(%{chat: chat})

      check_message = Chats.list_messages_for_chat(chat) |> List.first()

      assert message.id == check_message.id
      assert chat.id == check_message.chat_id
    end
  end
end
