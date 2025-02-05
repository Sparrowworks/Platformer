class_name Main extends Node

@onready var menu_theme: AudioStreamPlayer = $MenuTheme

func _ready() -> void:
	Composer.root = self
	Composer.load_scene("res://src/MainMenu/MainMenu.tscn")
