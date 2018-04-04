defmodule Munchkin.Server do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, %{}, options)
  end

end
