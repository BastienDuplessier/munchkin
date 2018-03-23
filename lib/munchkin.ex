defmodule Munchkin do
  @moduledoc """
  Documentation for Munchkin.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Munchkin.hello
      :world

  """
  def hello do
    :world
  end

  def start_server do
    IO.puts "Starting server"
    pid = spawn(Munchkin, :server, [%{}])
    :global.register_name(:server, pid)
    :ok
  end

  def send_to_server(params) do
    :global.whereis_name(:server) |> send(params)
  end

  def server(clients) do
    receive do
      {:msg, from, target, message} ->
        handle_message(from, target, message, clients)
        server(clients)
      {:login, name, pid} ->
        new_clients = handle_login(name, pid, clients)
        server(new_clients)
      {:logout, name} ->
        new_clients = handle_logout(name, clients)
        server(new_clients)
      {:stop, reason} ->
        IO.puts "Stopping server (#{reason})"
    end
  end

  def handle_message(from, target, message, clients) do
    clients[target] |> send({:msg, from, message})
  end

  def handle_login(name, pid, clients) do
    Map.put(clients, name, pid)
  end

  def handle_logout(name, clients) do
    Map.delete(clients, name)
  end

  def connect() do
    Node.connect(:"serv@adomik-3-3")
    pid = spawn(Munchkin, :client, [:none])
    Process.register pid, Munchkin.Client
    :ok
  end

  def client(:none) do
    IO.puts "Starting client"
    receive do
      {:login, name} ->
        IO.puts "Login as #{name}"
        send_to_server({:login, name, self()})
        client(name)
      {:stop, reason} ->
        IO.puts "Stopping (#{reason})"
    end
  end

  def client(name) do
    receive do
      {:msg, from, message} ->
        IO.puts "#{from} says : #{message}"
        client(name)
      {:tell, to, message} ->
        send_to_server({:msg, name, to, message})
        client(name)
      {:logout} ->
        IO.puts "Logout of #{name}"
        send_to_server({:logout, name})
        client(:none)
      {:stop, reason} ->
        IO.puts "Stopping (#{reason})"
    end
  end

  # Munchkin.login("Michel")
  def login(name) do
    Process.whereis(Munchkin.Client) |> send({:login, name})
    :ok
  end

  def logout() do
    Process.whereis(Munchkin.Client) |> send({:logout})
    :ok
  end

  # Munchkin.tell("Michel", "Hi!")
  def tell(to, message) do
    Process.whereis(Munchkin.Client) |> send({:tell, to, message})
    :ok
  end
end
