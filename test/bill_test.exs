defmodule BillTest do
  use ExUnit.Case, async: true # Yes! concurrent tests are possible!
  doctest Bill

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Bill.Repo)
  end

  test "greets the world" do
  # assert Bill.hello() == :world
  end
end
