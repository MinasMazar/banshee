import Config

config :banshee,
  player_executable: System.get_env("BANSHEE_PLAYER_EXECUTABLE", "afplay"),
  tts_executable: System.get_env("BANSHEE_TTS_EXECUTABLE", "espeak")
