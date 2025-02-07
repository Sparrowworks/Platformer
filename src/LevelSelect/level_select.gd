extends Control

@onready var level_title: Label = %LevelTitle
@onready var level_preview: TextureRect = %LevelPreview

var level_previews: Array = [
	preload("res://assets/images/Levels/Previews/1.png"),
	preload("res://assets/images/Levels/Previews/2.png"),
	preload("res://assets/images/Levels/Previews/3.png"),
	preload("res://assets/images/Levels/Previews/4.png"),
	preload("res://assets/images/Levels/Previews/5.png")
]

var level_idx: int = 0

func _on_play_button_pressed() -> void:
	var main: Main = get_parent()
	main.menu_theme.stop()
	Globals.go_to_with_fade("res://src/Game/Game.tscn")

func _on_menu_button_pressed() -> void:
	Globals.go_to_with_zigzag("res://src/MainMenu/MainMenu.tscn")

func _redraw_level() -> void:
	level_title.text = "Level " + str(level_idx+1)
	level_preview.texture = level_previews[level_idx]

func _on_prev_button_pressed() -> void:
	level_idx = clampi(level_idx - 1, 0, level_previews.size()-1)
	_redraw_level()

func _on_next_button_pressed() -> void:
	level_idx = clampi(level_idx + 1, 0, level_previews.size()-1)
	_redraw_level()
