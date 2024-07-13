defmodule Banshee.Server do
  import Banshee
  use GenServer

  @initial_state %{ports: %{}}

  def start_link(_) do
    GenServer.start_link(__MODULE__, @initial_state, name: __MODULE__)
  end

  @impl true
  def init(state), do: {:ok, state}

  def play(file) do
    GenServer.cast(__MODULE__, {:play, file})
  end

  @play_ended_message :play_ended
  def play(file, :wait) do
    GenServer.call(__MODULE__, {:play, file})
    receive do
      @play_ended_message -> :ok
    end
  end

  @impl true
  def handle_call({:play, file}, caller, state) do
    port = Port.open({:spawn, "#{player_executable()} #{file}"}, [])
    Port.monitor(port)
    {:reply, :ok, %{state | ports: Map.put(state.ports, port, caller)}}
  end

  @impl true
  def handle_cast({:play, file}, state) do
    port = Port.open({:spawn, "#{player_executable()} #{file}"}, [])
    {:noreply, %{state | ports: Map.put(state.ports, port, nil)}}
  end

  @impl true
  def handle_info({:DOWN, _ref, :port, down_port, _reason}, state) do
    {caller, ports} = Map.pop(state.ports, down_port)
    with {pid, _ref} <- caller, do: send(pid, :play_ended)
    {:noreply, %{state | ports: ports}}
  end
end
