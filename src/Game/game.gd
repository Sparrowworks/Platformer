extends Node2D

signal game_end()

@onready var game_theme: AudioStreamPlayer = $GameTheme
@onready var score_increase: AudioStreamPlayer = $ScoreIncrease

var level: Level

func _ready() -> void:
	_set_game_theme()
	_load_level()

func _set_game_theme() -> void:
	game_theme.stop()
	if Globals.is_alternative_ost:
		game_theme.stream = load("res://assets/audio/Levels/level" + str(Globals.level) + "Aggressive.mp3")
	else:
		game_theme.stream = load("res://assets/audio/Levels/level" + str(Globals.level) + ".mp3")

	game_theme.play()

func _load_level() -> void:
	var level_scene: PackedScene = ResourceLoader.load("res://src/Game/Level/Levels/Level" + str(Globals.level) + ".tscn")
	level = level_scene.instantiate()
	add_child(level)

	level.level_end.connect(_on_level_end)

func _on_level_end() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		Composer.load_scene("res://src/Game/Game.tscn")

	if Input.is_action_just_pressed("quit"):
		Composer.load_scene("res://src/MainMenu/MainMenu.tscn")
