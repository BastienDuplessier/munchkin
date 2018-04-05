defmodule Client do
  @moduledoc """
  Documentation for Client.
  """

  def login(name) do
    GenServer.call(Munchkin.Client, {:login, name})
  end

  def logout do
    GenServer.call(Munchkin.Client, {:logout})
  end

  def tell(to, message) do
    GenServer.call(Munchkin.Client, {:tell, to, message})
  end

  def yell(message) do
    GenServer.call(Munchkin.Client, {:yell, message})
  end
end
