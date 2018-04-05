defmodule MunchkinClient.Server do
  use GenServer

  def init(args) do
    Node.connect(:"server@adomik-3-3")
    {:ok, args}
  end

  def start_link(options \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, :none, options)
    Process.register pid, Munchkin.Client
    {:ok, pid}
  end

  def handle_call({:login, name} = params, _pid, :none) do
    case server_pid() |> GenServer.call(params) do
      :ok -> {:reply, :ok, name}
      error -> {:reply, error, :none}
    end
  end

  def handle_call({:logout}, _pid, name) do
    case server_pid() |> GenServer.call({:logout, name}) do
      :ok -> {:reply, :ok, :none}
      error -> {:reply, error, name}
    end
  end

  def handle_call({:tell, to, message}, _pid, name) do
    response = server_pid() |> GenServer.call({:tell, {name, to, message}})
    {:reply, response, name}
  end

  def handle_call({:yell, message}, _pid, name) do
    response = server_pid() |> GenServer.cast({:yell, {name, self(), message}})
    {:reply, response, name}
  end

  def handle_call({:rename, name}, _pid, name) do
    {:reply, {:err, "Already named #{name}"}, name}
  end

  def handle_call({:rename, name}, _pid, old_name) do
    case server_pid() |> GenServer.call({:rename, {old_name, name}}) do
      :ok -> {:reply, :ok, name}
      {:err, reason} -> {:reply, {:err, reason}, old_name}
    end
  end

  def handle_call(_, _pid, :none) do
    {:reply, {:err, "Not logged in"}, :none}
  end

  def handle_cast({:msg, from, message}, name) do
    IO.puts "[#{from}]: #{message}"
    {:noreply, name}
  end

  defp server_pid do
    :global.whereis_name(:server)
  end

end
