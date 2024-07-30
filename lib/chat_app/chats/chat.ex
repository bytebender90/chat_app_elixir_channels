defmodule ChatApp.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    field :name, :string

    many_to_many :users, ChatApp.Accounts.User, join_through: "chats_users"
    has_many :messages, ChatApp.Chats.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
