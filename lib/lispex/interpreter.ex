defmodule Lispex.Interpreter do
  @moduledoc """
  Interprets the program AST returned by the `Lispex.Parser` and returns the result of the last
  evaluated expression.
  """
  require Logger

  @spec interpret(Lispex.program()) :: {:ok, Lispex.literal()} | :error
  def interpret(_program) do
    Logger.error("Not implemented yet")
    Enum.random([:error, {:ok, 1}])
  end
end
