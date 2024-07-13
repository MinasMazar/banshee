defmodule Banshee do
  @moduledoc """
  Documentation for `Banshee`.
  """
  defdelegate play(file), to: Banshee.Server
  defdelegate play(file, mode), to: Banshee.Server

  @default_sound_file Path.expand("../../assets/banshee_scream.wav", __ENV__.file)
  def play do
    play(@default_sound_file)
  end

  @default_player_executable "afplay"
  def player_executable do
    Application.get_env(:banshee, :player_executable, @default_player_executable)
  end
end
