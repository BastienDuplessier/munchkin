defmodule MunchkinTest do
  use ExUnit.Case
  doctest Munchkin

  test "greets the world" do
    assert Munchkin.hello() == :world
  end
end
