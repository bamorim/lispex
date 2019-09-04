defmodule Lispex.Tokenizer do
  @moduledoc """
  The tokenizer. We are simply ensuring we have whitespace between parens and then splitting and
  ignoring all the whitespace.
  """

  @spec tokenize(String.t()) :: list(String.t())
  def tokenize(code) do
    code
    |> String.replace("(", " ( ")
    |> String.replace(")", " ) ")
    |> String.split()
  end
end
