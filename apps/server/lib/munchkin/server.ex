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

  def handle_call({:logout, name}, _pid, state) do
    {response, new_state} = logout(state, name)
    {:reply, response, new_state}
  end

  def handle_call({:tell, {from, to, message}}, _pid, state) do
    response = tell(from, to, message, state)
    {:reply, response, state}
  end

  def handle_call({:rename, names}, {pid, _ref}, state) do
    {response, new_state} = rename(names, pid, state)
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

  defp logout(state, name) do
    case Map.fetch(state, name) do
      {:ok, _pid} ->
        {:ok, Map.delete(state, name)}
      _ ->
        {{:err, "User not found"}, state}
    end
  end

  defp tell(from, to, message, state) do
    case Map.fetch(state, to) do
      {:ok, pid} -> GenServer.cast(pid, {:msg, from, message})
      _ -> {:err, "User not found"}
    end
  end

  defp rename({old, new}, pid, state) do
    case Map.fetch(state, old) do
      {:ok, ^pid} ->
        new_state = Map.delete(state, old)
        {:ok, Map.put(new_state, new, pid)}
      {:ok, _} ->
        {{:err, "Pid not corresponding"}, state}
      _ ->
        {{:err, "User not found"}, state}
    end
  end
end
