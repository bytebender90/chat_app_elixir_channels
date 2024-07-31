// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket} from "phoenix"

// And connect to the path in "lib/chat_app_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/chat_app_web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/chat_app_web/templates/layout/app.html.heex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/chat_app_web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic.
// Let's assume you have a channel with a topic named `room` and the
// subtopic is its id - in this case 42:

let chatId = window.chatId
let channel = socket.channel(`chat:${chatId}`, {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on(`chat:${chatId}:added_new_msg`, (message) => {
  displayMessage(message)
})

channel.on(`notification:${chatId}:added_new_msg`, (message) => {
  displayMessage(message)
})

channel.on(`chat:${chatId}:error_msg`, (message) => {
  displayErrorMessage(message)
})

document.querySelector("#message-form").addEventListener("submit", (e) => {
  e.preventDefault();
  const messageInput = e.target.querySelector("#message-input")
  console.log(messageInput.value, "Message oby")

  channel.push("new_message", { message: messageInput.value})

  messageInput.value = ""
})

const displayMessage = (message) => {
  const messageList = document.querySelector("#messages-list")

  const classes = message.sender_id == window.current_user_id ? "flex justify-end" : "flex"

  const template = `
    <div class="${classes}">
      <div class="bg-primary text-primary-foreground rounded-lg p-3 my-3 max-w-[65%]">
        <p>${message.content}</p>
        <div class="mt-1 text-xs text-muted-foreground">
          ${moment(message.inserted_at).format('LT')}
        </div>
      </div>
    </div>
  `
  messageList.innerHTML += template
}

const displayErrorMessage = ({message: value}) => {
  const messageInput = e.target.querySelector("#message-input")
  messageInput.value = value
}

export default socket
