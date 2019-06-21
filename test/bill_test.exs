defmodule BillTest do
  use ExUnit.Case
  doctest Bill

  test "greets the world" do
    assert Bill.hello() == :world
  end
end
