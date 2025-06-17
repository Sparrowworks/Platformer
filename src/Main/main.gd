class_name Main extends Node


func _ready() -> void:
	Globals.menu_theme = $MenuTheme
	Globals.button_click = $ButtonClick

	Globals.game_themes = [
		$GameTheme1,
		$GameTheme2,
		$GameTheme3,
		$GameTheme4,
		$GameTheme5,
		$GameTheme6,
		$GameTheme7,
		$GameTheme8,
		$GameTheme9,
		$GameTheme10
	]

	Composer.root = self
	Composer.load_scene("res://src/MainMenu/MainMenu.tscn")
