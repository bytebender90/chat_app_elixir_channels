defmodule ChatApp.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias ChatApp.Repo

  alias ChatApp.Accounts.User
  alias ChatApp.Chats.Chat
  alias ChatApp.Chats.Message

  @doc """
  Returns the list of chats.

  ## Examples

      iex> list_chats()
      [%Chat{}, ...]

  """
  def list_chats do
    Repo.all(Chat)
  end

  @doc """
  Gets a single chat.

  Raises `Ecto.NoResultsError` if the Chat does not exist.

  ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat!(id), do: Repo.get!(Chat, id)

  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat(attrs \\ %{}) do
    %Chat{}
    |> Chat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chat.

  ## Examples

      iex> update_chat(chat, %{field: new_value})
      {:ok, %Chat{}}

      iex> update_chat(chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat(%Chat{} = chat, attrs) do
    chat
    |> Chat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chat.

  ## Examples

      iex> delete_chat(chat)
      {:ok, %Chat{}}

      iex> delete_chat(chat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat(%Chat{} = chat) do
    Repo.delete(chat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat changes.

  ## Examples

      iex> change_chat(chat)
      %Ecto.Changeset{data: %Chat{}}

  """
  def change_chat(%Chat{} = chat, attrs \\ %{}) do
    Chat.changeset(chat, attrs)
  end

  @doc """
  Returns the list of messages for a specific chats.

  ## Examples

      iex> list_messages_for_chat(%Chat{} = chat)
      [%Message{}, ...]

  """
  def list_messages_for_chat(%Chat{id: chat_id}) do
    from(m in Message,
      where: m.chat_id == ^chat_id,
      order_by: [desc: m.inserted_at]
    )
    |> Repo.all()
  end

  # @doc """
  # Gets a single message.

  # Raises `Ecto.NoResultsError` if the Message does not exist.

  # ## Examples

  #     iex> get_message!(123)
  #     %Message{}

  #     iex> get_message!(456)
  #     ** (Ecto.NoResultsError)

  # """
  # def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%User{} = current_user, %Chat{} = chat, %{field: value})
      {:ok, %Message{}}

      iex> create_message(%User{} = current_user, %Chat{} = chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(%User{} = current_user, %Chat{} = chat, attrs \\ %{}) do
    # TODO: Validate the user belongs to current chat
    attrs =
      attrs
      |> Map.put(:chat_id, chat.id)
      |> Map.put(:sender_id, current_user.id)

    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  # @doc """
  # Updates a message.

  # ## Examples

  #     iex> update_message(message, %{field: new_value})
  #     {:ok, %Message{}}

  #     iex> update_message(message, %{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  # """
  # def update_message(%Message{} = message, attrs) do
  #   message
  #   |> Message.changeset(attrs)
  #   |> Repo.update()
  # end

  # @doc """
  # Deletes a message.

  # ## Examples

  #     iex> delete_message(message)
  #     {:ok, %Message{}}

  #     iex> delete_message(message)
  #     {:error, %Ecto.Changeset{}}

  # """
  # def delete_message(%Message{} = message) do
  #   Repo.delete(message)
  # end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking message changes.

  # ## Examples

  #     iex> change_message(message)
  #     %Ecto.Changeset{data: %Message{}}

  # """
  # def change_message(%Message{} = message, attrs \\ %{}) do
  #   Message.changeset(message, attrs)
  # end
end
