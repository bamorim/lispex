defmodule Lispex do
  @moduledoc """
  Documentation for Lispex.
  """

  @type program :: list(expression())
  @type expression :: literal | list(expression)
  @type literal :: integer() | float() | String.t()
end
