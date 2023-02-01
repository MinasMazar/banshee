import Config

config :banshee,
  alarm_file: Path.expand("../assets/alarm.wav", __DIR__),
  player_executable: "afplay",
  tts_executable: "espeak"
