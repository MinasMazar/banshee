# Banshee

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `banshee` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:banshee, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/banshee>.

## Configuration

```elixir
# config/runtime.exs

config :banshee,
  alarm_file: Path.expand("../../assets/banshee_scream.wav", __ENV__.file),
  player_executable: "afplay",
  tts_executable: "espeak"
```
