extends Control

@onready var scores: Label = $Scores


func _on_menu_button_pressed() -> void:
	Composer.load_scene("res://src/MainMenu/MainMenu.tscn")
