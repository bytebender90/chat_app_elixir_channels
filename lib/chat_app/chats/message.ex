defmodule ChatApp.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :content, :chat_id, :sender_id, :inserted_at]}

  schema "messages" do
    field :content, :string
    belongs_to :chat, ChatApp.Chats.Chat
    belongs_to :sender, ChatApp.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:content, :chat_id, :sender_id])
    |> validate_required([:content])
  end
end
