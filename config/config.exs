import Config

config :banshee,
  alarm_file: Path.expand("../../assets/banshee_scream.wav", __ENV__.file),
  player_executable: System.get_env("BANSHEE_PLAYER_EXECUTABLE", "afplay"),
  tts_executable: System.get_env("BANSHEE_TTS_EXECUTABLE", "espeak")
