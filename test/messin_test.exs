defmodule MessinTest do
  use ExUnit.Case
  doctest Messin

  test "greets the world" do
    assert Messin.hello() == :world
  end
end
