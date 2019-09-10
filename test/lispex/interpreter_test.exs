defmodule Lispex.InterpreterTest do
  use ExUnit.Case

  test "it can interpret literal only programs with single expression" do
    assert {:ok, 1} = Lispex.Interpreter.interpret([1])
  end

  test "it can apply simple functions without nested expressions" do
    assert {:ok, 1} = Lispex.Interpreter.interpret([["id", 1]])
  end

  test "it can apply simple functions with nested expressions" do
    assert {:ok, 1} = Lispex.Interpreter.interpret([["id", ["id", 1]]])
  end

  test "last function" do
    assert {:ok, 3} = Lispex.Interpreter.interpret([["last", 1, 2, 3]])
  end
end
