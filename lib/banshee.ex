defmodule Banshee do
  @moduledoc """
  Documentation for `Banshee`.
  """
  defdelegate play(file), to: Banshee.Server
  defdelegate play(file, mode), to: Banshee.Server

  def scream! do
    Application.get_env(:banshee, :alarm_file) |> play()
  end

  @default_player_executable "afplay"
  def player_executable do
    Application.get_env(:banshee, :player_executable, @default_player_executable)
  end
end
