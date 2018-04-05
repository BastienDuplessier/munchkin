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

  def tell do
  end

  def yell do
  end
end
