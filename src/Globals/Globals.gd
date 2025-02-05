extends Node

### Game variables
var level: int = 1

### Settings
var is_alternative_ost: bool = false
var is_speedrun_mode: bool = false

var master_volume: float = 100.0
var music_volume: float = 100.0
var sfx_volume: float = 100.0

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
