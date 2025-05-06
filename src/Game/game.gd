class_name Game extends Node2D

signal game_paused()
signal game_end()

@onready var score_increase: AudioStreamPlayer = $ScoreIncrease
@onready var win_sound: AudioStreamPlayer = $WinSound
@onready var end_timer: Timer = $EndTimer

@onready var speedrun_ui: CanvasLayer = $SpeedrunUI
@onready var level_1: Label = %Level1
@onready var level_2: Label = %Level2
@onready var level_3: Label = %Level3
@onready var level_4: Label = %Level4
@onready var level_5: Label = %Level5
@onready var total_time: Label = %Level6
@onready var paused: Label = %Paused

var level: Level
var is_counting_time: bool = true
var is_game_over: bool = false

func _ready() -> void:
	Globals.game = self
	Globals.set_game_theme()
	_load_level()

	if Globals.is_speedrun_mode:
		if level_1 == null:
			await level_1.ready

		if level_2 == null:
			await level_2.ready

		if level_3 == null:
			await level_3.ready

		if level_4 == null:
			await level_4.ready

		if level_5 == null:
			await level_5.ready

		if total_time == null:
			await total_time.ready

		speedrun_ui.show()
		_setup_speedrun()

func _setup_speedrun() -> void:
	Globals.start_time = Time.get_unix_time_from_system() * 1000.0

	if Globals.is_new_game:
		level_1.show()
		level_2.show()
		level_3.show()
		level_4.show()
		level_5.show()
		total_time.show()
	else:
		var level_time_label: Label = $SpeedrunUI/Control/VBoxContainer.get_node("Level" + str(Globals.level))
		level_time_label.show()

func _load_level() -> void:
	Globals.reset_level()

	var level_scene: PackedScene = ResourceLoader.load("res://src/Game/Level/Levels/Level" + str(Globals.level) + ".tscn")
	level = level_scene.instantiate()
	add_child(level)

	level.level_end.connect(_on_level_end)

func _on_level_end() -> void:
	is_counting_time = false

	if Globals.is_new_game:
		Globals.end_player_health = Globals.player_health

	Globals.total_score += Globals.level_score
	Globals.total_time += (level.level_time - Globals.level_time)
	Globals.total_kills += Globals.level_kills
	Globals.total_score += Globals.player_health * 1000

	Globals.game_theme.stop()
	win_sound.play()

	await win_sound.finished

	score_increase.play()
	end_timer.start()

func _process(_delta: float) -> void:
	if Globals.is_speedrun_mode and is_counting_time:
		var time: float = Time.get_unix_time_from_system() * 1000.0
		var diff: float = (time - Globals.start_time) / 1000.0

		Globals.level_speedrun_times[Globals.level] = diff
		Globals.level_speedrun_times[6] = Globals.level_speedrun_times[1] + Globals.level_speedrun_times[2] + Globals.level_speedrun_times[3] + Globals.level_speedrun_times[4] + Globals.level_speedrun_times[5]
		level_1.text = "Level 1: " + str(Globals.level_speedrun_times[1])
		level_2.text = "Level 2: " + str(Globals.level_speedrun_times[2])
		level_3.text = "Level 3: " + str(Globals.level_speedrun_times[3])
		level_4.text = "Level 4: " + str(Globals.level_speedrun_times[4])
		level_5.text = "Level 5: " + str(Globals.level_speedrun_times[5])
		total_time.text = "Total: " + str(Globals.level_speedrun_times[6])

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		set_process_input(false)
		get_tree().paused = true
		game_paused.emit()

	if Input.is_action_just_pressed("restart"):
		if Globals.is_new_game:
			Globals.player_health = Globals.end_player_health
		else:
			Globals.player_health = 3

		Globals.go_to_with_fade("res://src/Game/Game.tscn")

	if Input.is_action_just_pressed("quit"):
		if not Composer._is_loading:
			Globals.game_theme.stop()
			Globals.go_to_with_fade("res://src/MainMenu/MainMenu.tscn")

	if Input.is_action_just_pressed("switch") and is_game_over:
		if Globals.is_new_game:
			Globals.level += 1
			if Globals.level == 6:
				Globals.total_score += 10000
				Globals.go_to_with_fade("res://src/GameEnd/GameEnd.tscn")
			else:
				Globals.go_to_with_zigzag("res://src/Game/Game.tscn")
		else:
			Globals.go_to_with_fade("res://src/GameEnd/GameEnd.tscn")

func _on_end_timer_timeout() -> void:
	is_game_over = true

	if Globals.level_time > 0:
		Globals.total_score += 1
		Globals.level_score += 1
		Globals.level_time -= 1
		Globals.player.update_ui.emit(Globals.level_score, Globals.level_coins, Globals.player_health, Globals.level, Globals.level_time)
	else:
		score_increase.stop()
		game_end.emit()


func _on_paused_game_unpaused() -> void:
	get_tree().paused = false
	Globals.button_click.play()

	await get_tree().create_timer(0.5).timeout
	set_process_input(true)
