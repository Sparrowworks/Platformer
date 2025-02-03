extends Control

@onready var level_select_panel: TextureRect = $LevelSelectPanel

func _on_play_button_pressed() -> void:
	level_select_panel.show()

func _on_options_button_pressed() -> void:
	Composer.load_scene("res://src/Settings/Settings.tscn")

func _on_help_button_pressed() -> void:
	Composer.load_scene("res://src/Help/Help.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_x_button_pressed() -> void:
	level_select_panel.hide()


func _on_new_game_button_pressed() -> void:
	pass # Replace with function body.


func _on_level_select_button_pressed() -> void:
	pass # Replace with function body.
