# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ChatApp.Repo.insert!(%ChatApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ChatApp.Repo
alias ChatApp.Accounts.User

password = "Password123!"

{:ok, %User{id: u1_id} = user1} =
  Repo.insert(%User{
    email: "user1@gmail.com",
    password: password,
    hashed_password: Bcrypt.hash_pwd_salt(password),
    confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)
  })

{:ok, %User{id: u2_id} = user2} =
  Repo.insert(%User{
    email: "user2@gmail.com",
    password: password,
    hashed_password: Bcrypt.hash_pwd_salt(password),
    confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)
  })

{:ok, %User{id: u3_id} = user3} =
  Repo.insert(%User{
    email: "user3@gmail.com",
    password: password,
    hashed_password: Bcrypt.hash_pwd_salt(password),
    confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)
  })

{:ok, chat1} =
  %{
    name: "Chat one",
    user_ids: [
      Integer.to_string(u1_id),
      Integer.to_string(u2_id)
    ]
  }
  |> ChatApp.Chats.create_chat()

{:ok, chat2} =
  %{
    name: "Chat two",
    user_ids: [
      Integer.to_string(u3_id),
      Integer.to_string(u1_id)
    ]
  }
  |> ChatApp.Chats.create_chat()

{:ok, chat3} =
  %{
    name: "Chat three",
    user_ids: [
      Integer.to_string(u2_id),
      Integer.to_string(u3_id)
    ]
  }
  |> ChatApp.Chats.create_chat()

ChatApp.Chats.create_message(
  user1,
  chat1,
  %{
    content: "Hi user 2"
  }
)

ChatApp.Chats.create_message(
  user2,
  chat1,
  %{
    content: "Hello user 1"
  }
)

ChatApp.Chats.create_message(
  user1,
  chat2,
  %{
    content: "Hi user 3"
  }
)

ChatApp.Chats.create_message(
  user3,
  chat2,
  %{
    content: "Hello user 1"
  }
)

ChatApp.Chats.create_message(
  user2,
  chat3,
  %{
    content: "Hi user 3"
  }
)

ChatApp.Chats.create_message(
  user3,
  chat3,
  %{
    content: "Hello user 2"
  }
)
