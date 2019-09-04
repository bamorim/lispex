defmodule Mix.Tasks.LispexRepl do
  use Mix.Task

  @impl Mix.Task
  def run(_) do
    IO.puts("Welcome to Lispex REPL! Type :q to exit at any time.")
    Lispex.REPL.run()
  end
end
