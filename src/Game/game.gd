extends Node2D

signal game_end()

@onready var game_theme: AudioStreamPlayer = $GameTheme
@onready var score_increase: AudioStreamPlayer = $ScoreIncrease

func _ready() -> void:
	_set_game_theme()
	_load_level()

func _set_game_theme() -> void:
	game_theme.stop()
	#if Globals.is_alternative_ost:
		#game_theme.track = load("res://assets/audio/Levels/level" + str(Globals.level) + "Aggressive.mp3")
	#else:
		#game_theme.track = load("res://assets/audio/Levels/level" + str(Globals.level) + ".mp3")

	#game_theme.play()

func _load_level() -> void:
	var level_scene: PackedScene = ResourceLoader.load("res://src/Game/Level/Levels/Level" + str(Globals.level) + ".tscn")
	add_child(level_scene.instantiate())
