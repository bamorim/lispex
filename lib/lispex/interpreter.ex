defmodule Lispex.Interpreter do
  @moduledoc """
  Interprets the program AST returned by the `Lispex.Parser` and returns the result of the last
  evaluated expression.
  """
  require Logger

  @spec interpret(Lispex.program()) :: {:ok, Lispex.literal()} | :error
  def interpret([expression]) do
    eval_expression(expression)
  end

  @spec eval_expression(Lispex.expression()) :: {:ok, Lispex.literal()} | :error
  def eval_expression(literal) when not is_list(literal), do: {:ok, literal}

  def eval_expression([fname | expressions]) do
    evaluated_either_arguments = Enum.map(expressions, &eval_expression/1)

    if Enum.all?(evaluated_either_arguments, fn either -> match?({:ok, _}, either) end) do
      evaluated_arguments = Enum.map(evaluated_either_arguments, fn {:ok, val} -> val end)
      apply_function(fname, evaluated_arguments)
    else
      :error
    end
  end

  def apply_function("id", [val | _]), do: {:ok, val}
  def apply_function("last", arguments), do: {:ok, List.last(arguments)}
  def apply_function("+", arguments), do: {:ok, Enum.sum(arguments)}
end
