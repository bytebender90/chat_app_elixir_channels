defmodule ChatApp.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :name, :string, null: true

      timestamps(type: :utc_datetime)
    end

    create table(:chats_users) do
      add :chat_id, references(:chats, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:chats_users, [:chat_id])
    create index(:chats_users, [:user_id])
  end
end
