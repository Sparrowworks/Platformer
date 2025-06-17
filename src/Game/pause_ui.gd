extends Label

signal game_unpaused

@onready var pause_animation: AnimationPlayer = $PauseAnimation


func _ready() -> void:
	hide()
	set_process_input(false)


func _on_game_game_paused() -> void:
	show()
	pause_animation.play("Blink")
	Globals.button_click.play()

	await get_tree().create_timer(0.5).timeout
	set_process_input(true)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_animation.stop()
		game_unpaused.emit()
		set_process_input(false)
		hide()
