defmodule Banshee do
  @moduledoc """
  Documentation for `Banshee`.
  """
  use GenServer

  @initial_state %{ports: [], voice: "default", outfile: nil}
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, @initial_state}
  end

  def alarm!, do: play(default_alarm_file())
  def play(file) when is_binary(file), do: play(__MODULE__, file)
  def play(pid, file) do
    GenServer.call(pid, {:alarm, true, file})
  end

  def speak(message) when is_binary(message), do: speak(Process.whereis(__MODULE__), message)
  def speak(pid, message) when is_pid(pid) do
    GenServer.call(pid, {:speak, message})
  end
  def speak(message, options) when is_binary(message) and is_list(options) do
    speak(__MODULE__, message, options)
  end
  def speak(pid, message, options) do
    GenServer.call(pid, {:speak, message, options})
  end

  def mute(pid \\ __MODULE__) do
    GenServer.call(pid, {:alarm, false})
  end

  def handle_call({:alarm, true, file}, _caller, state) do
    {:reply, true, start_play(state, file)}
  end

  def handle_call({:alarm, false}, _caller, state) do
    {:reply, true, stop_all(state)}
  end

  def handle_call({:speak, message}, _caller, state) do
    {:reply, true, start_tts(state, message)}
  end

  def handle_call({:speak, message, voice: voice}, _caller, state) do
    {:reply, true, start_tts(%{state | voice: voice}, message)}
  end

  def handle_call({:speak, message, outfile: outfile}, _caller, state) do
    {:reply, true, start_tts(%{state | outfile: outfile}, message)}
  end

  def handle_call({:speak, message, _options}, caller, state) do
    handle_call({:speak, message}, caller, state)
  end

  defp start_play(state = %{ports: ports}, file) do
    port = Port.open({:spawn, "#{player_executable()} #{file}"}, [])
    %{state | ports: [port | ports]}
  end

  defp stop_all(state = %{ports: ports}) do
    for port <- ports, do: Port.close(port)
    %{state | ports: []}
  end

  defp start_tts(state = %{ports: ports, voice: voice, outfile: nil}, message) do
    port = Port.open({:spawn, "#{tts_executable()} -v #{voice} \"#{message}\""}, [])
    %{state | ports: [port | ports], voice: voice}
  end

  defp start_tts(state = %{ports: ports, voice: voice, outfile: outfile}, message) do
    port = Port.open({:spawn, "#{tts_executable()} -w #{outfile} -v #{voice} \"#{message}\""}, [])
    %{state | ports: [port | ports], voice: voice}
  end

  @default_player_executable "afplay"
  defp player_executable do
    Application.get_env(:banshee, :player_executable, @default_player_executable)
  end

  @default_tts_executable "espeak"
  defp tts_executable do
    Application.get_env(:banshee, :tts_executable, @default_tts_executable)
  end

  @default_alarm_file Path.expand("../assets/alarm.wav", __DIR__)
  defp default_alarm_file do
    Application.get_env(:basnhee, :alarm_file, @default_alarm_file)
  end
end
