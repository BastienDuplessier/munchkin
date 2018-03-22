# Munchkin

Little Elixir chat app.

## Installation

Just clone the project.

## Usage

First run the server in a first shell. Don't forget to use the same cookie for server and client. Don't change the sname, it's hardcoded in the client.
```bash
iex --cookie munchkin --sname serv -S mix
```

Inside this iex session, run the following.
```elixir
Munchkin.start_server
```

The server is ready !

Now, you can run any number of clients you want. This time you can use any sname you want.
```bash
iex --cookie munchkin --sname client1 -S mix
```

After you'll need to connect to the server and then to login with a name.
```elixir
Munchkin.connect
Munchkin.login("Jean-Michel Sature")
```

Now you can send messages though the tell function.
```elixir
Munchkin.tell("Jean-Michel Amoité", "Hello World !")
```
