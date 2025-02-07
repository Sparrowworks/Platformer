extends Node

### Game variables
var level: int = 1

var menu_theme: AudioStreamPlayer
var game_theme: AudioStreamPlayer

var _current_game_theme: String = ""

### Settings
var is_alternative_ost: bool = false
var is_speedrun_mode: bool = false

var master_volume: float = 100.0
var music_volume: float = 100.0
var sfx_volume: float = 100.0

func set_game_theme() -> void:
	if _current_game_theme == "":
		if Globals.is_alternative_ost:
			_current_game_theme = "res://assets/audio/Levels/level" + str(Globals.level) + "Aggressive.mp3"
		else:
			_current_game_theme = "res://assets/audio/Levels/level" + str(Globals.level) + ".mp3"

		game_theme.stream = load(_current_game_theme)
		game_theme.play()
	else:
		var new_game_theme: String
		if Globals.is_alternative_ost:
			new_game_theme = "res://assets/audio/Levels/level" + str(Globals.level) + "Aggressive.mp3"
		else:
			new_game_theme = "res://assets/audio/Levels/level" + str(Globals.level) + ".mp3"

		if _current_game_theme != new_game_theme:
			_current_game_theme = new_game_theme

			game_theme.stop()
			game_theme.stream = load(_current_game_theme)
			game_theme.play()

func go_to_with_fade(scene: String) -> void:
	var transition: Node = Composer.setup_load_screen("res://src/Composer/LoadingScreens/Fade/FadeScreen.tscn")

	if transition:
		await transition.finished_fade_in
		Composer.load_scene(scene)

func go_to_with_zigzag(scene: String) -> void:
	var transition: ZigZag = Composer.setup_load_screen("res://src/Composer/LoadingScreens/ZigZag/ZigZagScreen.tscn")

	if transition:
		await transition.finished_moving
		Composer.load_scene(scene)
