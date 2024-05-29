defmodule AutoGraderTest do
  use ExUnit.Case
  doctest AutoGrader

  test "greets the world" do
    assert AutoGrader.hello() == :world
  end
end
