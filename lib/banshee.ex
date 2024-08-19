defmodule Banshee do
  @moduledoc """
  Documentation for `Banshee`.
  """
  defdelegate play(file), to: Banshee.Server
  defdelegate play(file, mode), to: Banshee.Server
  defdelegate stop(), to: Banshee.Server

  @default_alarm_file Path.expand("../../assets/banshee_scream.wav", __ENV__.file)
  def scream! do
    Application.get_env(:banshee, :alarm_file, @default_alarm_file) |> play()
  end

  @default_player_executable "afplay"
  def player_executable do
    Application.get_env(:banshee, :player_executable, @default_player_executable)
  end
end
