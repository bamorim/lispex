defmodule Lispex.ParserTest do
  use ExUnit.Case
  use ExUnitProperties

  import Lispex.Parser

  property "can parse everything" do
    check all(prog <- program()) do
      assert {:ok, ^prog} = prog |> program_to_tokens() |> parse()
    end
  end

  property "unclosed ( should give an error" do
    check all(exp <- expression()) do
      assert {:error, :unexpected_end} =
               exp
               |> expression_to_tokens()
               |> insert_token_at_random_position("(")
               |> parse()
    end
  end

  property "extra ) should give an error" do
    check all(exp <- expression()) do
      assert {:error, :unexpected_closing_parens} =
               exp
               |> expression_to_tokens()
               |> insert_token_at_random_position(")")
               |> parse()
    end
  end

  def insert_token_at_random_position(tokens, token) do
    List.insert_at(tokens, Enum.random(0..length(tokens)), token)
  end

  # Converting an AST to tokens is way easier.
  def program_to_tokens(expressions) do
    Enum.flat_map(expressions, &expression_to_tokens/1)
  end

  def expression_to_tokens(list) when is_list(list) do
    ["(" | program_to_tokens(list)] ++ [")"]
  end

  def expression_to_tokens(x), do: [to_string(x)]

  # Generators
  def program, do: list_of(expression())

  def expression do
    tree(terminal(), fn node ->
      map({lisp_atom(), list_of(node)}, fn {fnname, args} -> [fnname | args] end)
    end)
  end

  def terminal do
    one_of([integer(), float(), lisp_atom()])
  end

  def lisp_atom do
    chars = Enum.map(?a..?z, &constant/1)
    map({one_of(chars), string(:alphanumeric)}, fn {f, l} -> "#{List.to_string([f])}#{l}" end)
  end
end
