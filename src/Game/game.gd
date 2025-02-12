class_name Game extends Node2D

signal game_end()

@onready var score_increase: AudioStreamPlayer = $ScoreIncrease
@onready var win_sound: AudioStreamPlayer = $WinSound
@onready var end_timer: Timer = $EndTimer

var level: Level
var is_game_end: bool = false

func _ready() -> void:
	Globals.game = self
	Globals.set_game_theme()
	_load_level()

func _load_level() -> void:
	Globals.reset_level()

	var level_scene: PackedScene = ResourceLoader.load("res://src/Game/Level/Levels/Level" + str(Globals.level) + ".tscn")
	level = level_scene.instantiate()
	add_child(level)

	level.level_end.connect(_on_level_end)

func _on_level_end() -> void:
	Globals.total_score += Globals.level_score
	Globals.total_time += (level.level_time - Globals.level_time)
	Globals.total_kills += Globals.level_score

	Globals.game_theme.stop()
	win_sound.play()

	await win_sound.finished

	score_increase.play()
	end_timer.start()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		Globals.go_to_with_fade("res://src/Game/Game.tscn")

	if Input.is_action_just_pressed("quit"):
		if not Composer._is_loading:
			Globals.game_theme.stop()
			Globals.go_to_with_fade("res://src/MainMenu/MainMenu.tscn")

	if Input.is_action_just_pressed("switch"):
		if Globals.is_new_game:
			Globals.level += 1
			if Globals.level == 6:
				Globals.go_to_with_fade("res://src/GameEnd/GameEnd.tscn")
			else:
				Globals.go_to_with_zigzag("res://src/Game/Game.tscn")
		else:
			Globals.go_to_with_fade("res://src/GameEnd/GameEnd.tscn")

func _on_end_timer_timeout() -> void:
	if Globals.level_time > 0:
		Globals.total_score += 1
		Globals.level_score += 1
		Globals.level_time -= 1
		Globals.player.update_ui.emit(Globals.level_score, Globals.level_coins, Globals.player_health, Globals.level, Globals.level_time)
	else:
		score_increase.stop()
		game_end.emit()
		is_game_end = true
