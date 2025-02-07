extends Node2D

signal game_end()

@onready var score_increase: AudioStreamPlayer = $ScoreIncrease

var level: Level

func _ready() -> void:
	Globals.set_game_theme()
	_load_level()

func _load_level() -> void:
	var level_scene: PackedScene = ResourceLoader.load("res://src/Game/Level/Levels/Level" + str(Globals.level) + ".tscn")
	level = level_scene.instantiate()
	add_child(level)

	level.level_end.connect(_on_level_end)

func _on_level_end() -> void:
	Globals.game_theme.stop()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		Globals.go_to_with_fade("res://src/Game/Game.tscn")

	if Input.is_action_just_pressed("quit"):
		Globals.game_theme.stop()
		Globals.go_to_with_fade("res://src/MainMenu/MainMenu.tscn")
