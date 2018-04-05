defmodule Munchkin.Server do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, %{}, options)
  end

  def handle_call({:login, name}, {pid, _ref}, state) do
    {response, new_state} = login(state, name, pid)
    {:reply, response, new_state}
  end

  def handle_call(_, _, state) do
    {:reply, {:err, "not found"}, state}
  end

  defp login(state, name, from) do
    case Map.fetch(state, name) do
      {:ok, ^from} ->
        {{:err, "Already logged in"}, state}
      {:ok, _} ->
        {{:err, "Name already taken"}, state}
      _ ->
        {:ok, Map.put(state, name, from)}
    end
  end

end
