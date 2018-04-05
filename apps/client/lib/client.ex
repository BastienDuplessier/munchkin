defmodule Client do
  @moduledoc """
  Documentation for Client.
  """

  def login(name) do
    GenServer.call(Munchkin.Client, {:login, name})
  end

  def login do
  end

  def tell do
  end

  def yell do
  end
end
