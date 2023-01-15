import Config

config :banshee,
  default_alarm_file: Path.expand("../assets/alarm.mp3", __DIR__),
  player_executable: "afplay",
  tts_executable: "espeak"
