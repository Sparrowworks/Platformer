extends Control

func _on_play_button_pressed() -> void:
	pass # Replace with function body.

func _on_options_button_pressed() -> void:
	pass # Replace with function body.

func _on_help_button_pressed() -> void:
	Composer.load_scene("res://src/Help/Help.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
