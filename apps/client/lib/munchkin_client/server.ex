defmodule MunchkinClient.Server do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start_link(options \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, :none, options)
    Process.register pid, Munchkin.Client
    {:ok, pid}
  end

end
