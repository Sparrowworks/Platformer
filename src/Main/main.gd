class_name Main extends Node

func _ready() -> void:
	Globals.menu_theme = $MenuTheme
	Globals.game_theme = $GameTheme
	Globals.button_click = $ButtonClick

	Composer.root = self
	Composer.load_scene("res://src/MainMenu/MainMenu.tscn")
