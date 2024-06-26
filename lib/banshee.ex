defmodule Banshee do
  @moduledoc """
  Documentation for `Banshee`.
  """
  defdelegate play(file), to: Banshee.Player
  defdelegate play(file, mode), to: Banshee.Player
end
