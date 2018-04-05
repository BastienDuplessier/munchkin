defmodule MunchkinClient.Supervisor do
  @moduledoc """
  Documentation for MunchkinClient.Supervisor.
  """
  use Supervisor

  def init(_) do
    children = [
      worker(MunchkinClient.Server, [], restart: :permanent)
    ]

    supervise(children, strategy: :one_for_one)
  end

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end
end
