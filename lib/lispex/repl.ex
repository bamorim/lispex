defmodule Lispex.REPL do
  @moduledoc """
  Implements a simple Read-Evaluate-Print-Loop.
  For now, everything is stateless so there is no context.
  """

  alias Lispex.{Tokenizer, Parser, Interpreter}

  @type eval_result ::
          {:ok, Lispex.literal()}
          | {:parsing_error, Parser.error()}
          | :runtime_error
          | :stop

  @spec run :: :ok
  def run do
    read()
    |> evaluate()
    |> print()
    |> loop()
  end

  @spec read() :: String.t()
  defp read do
    IO.write("> ")

    :line
    |> IO.read()
    |> String.trim()
  end

  @spec evaluate(String.t()) :: eval_result()
  defp evaluate(":q"), do: :stop

  defp evaluate(code) do
    with tokens <- Tokenizer.tokenize(code),
         {:parse, {:ok, program}} <- {:parse, Parser.parse(tokens)},
         {:interpret, {:ok, result}} <- {:interpret, Interpreter.interpret(program)} do
      {:ok, result}
    else
      {:parse, {:error, error}} -> {:parsing_error, error}
      {:interpret, _} -> :runtime_error
    end
  end

  @spec print(eval_result()) :: :continue | :stop
  defp print(:stop), do: :stop

  defp print({:parsing_error, error}) do
    IO.puts("Parsing Error: #{error}!")
    :continue
  end

  defp print(:runtime_error) do
    IO.puts("Runtime Error!")
    :continue
  end

  defp print({:ok, result}) do
    IO.puts(to_string(result))
    :continue
  end

  @spec loop(:stop | :continue) :: :ok
  defp loop(:stop), do: :ok
  defp loop(:continue), do: run()
end
