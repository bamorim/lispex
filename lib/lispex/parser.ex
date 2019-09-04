defmodule Lispex.Parser do
  @moduledoc """
  ABNF grammar:

      program = expressions
      expressions = expression [" " expressions]
      expression = "(" expressions ")" / literal
      literal = literal_char *
      literal_char = ANY_UNICODE_THAT_IS_NOT_PARENS

  The simplification here is that anything is a literal, but literals that matches the integer and
  float regexes will be treated as integers and floats, the rest are atoms.
  """

  @type error :: :unexpected_end | :unexpected_closing_parens

  @spec parse(list(String.t())) :: {:ok, Lispex.program()} | {:error, error()}
  def parse(tokens), do: parse(tokens, [[]])

  defp parse(["(" | tokens], stack) do
    parse(tokens, [[] | stack])
  end

  defp parse([")" | tokens], [curr, prev | stack]) do
    parse(tokens, [[Enum.reverse(curr) | prev] | stack])
  end

  defp parse([")" | _], [_curr]) do
    {:error, :unexpected_closing_parens}
  end

  defp parse([token | tokens], [curr | stack]) do
    parse(tokens, [[parse_literal(token) | curr] | stack])
  end

  defp parse([], [expressions]), do: {:ok, Enum.reverse(expressions)}
  defp parse([], _), do: {:error, :unexpected_end}

  defp parse_literal(literal) do
    case Integer.parse(literal) do
      {int, ""} ->
        int

      _ ->
        case Float.parse(literal) do
          {float, ""} -> float
          _ -> literal
        end
    end
  end
end
