extends Control

@onready var scores: Label = $Scores


func _on_menu_button_pressed() -> void:
	Globals.go_to_with_zigzag("res://src/MainMenu/MainMenu.tscn")
