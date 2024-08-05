import Config

config :banshee,
  alarm_file: Path.expand("../../assets/banshee_scream.wav", __ENV__.file),
  player_executable: "afplay",
  tts_executable: "espeak"
