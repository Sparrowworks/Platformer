extends Control

@onready var level_select_panel: TextureRect = $LevelSelectPanel
@onready var version_text: Label = $MarginContainer/VersionText

var main: Main


func _ready() -> void:
	if not Globals.menu_theme.playing:
		Globals.menu_theme.play()

	version_text.text = "v" + ProjectSettings.get_setting("application/config/version")

	if OS.get_name() == "Web":
		$Buttons/QuitButton.hide()


func _on_play_button_pressed() -> void:
	# Show a game select panel when play is pressed
	Globals.button_click.play()
	level_select_panel.show()


func _on_options_button_pressed() -> void:
	Globals.go_to_with_zigzag("res://src/Settings/Settings.tscn")


func _on_help_button_pressed() -> void:
	Globals.go_to_with_zigzag("res://src/Help/Help.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_x_button_pressed() -> void:
	Globals.button_click.play()
	level_select_panel.hide()


func _on_new_game_button_pressed() -> void:
	Globals.menu_theme.stop()
	Globals.new_game()
	Globals.go_to_with_fade("res://src/Game/Game.tscn")


func _on_level_select_button_pressed() -> void:
	Globals.go_to_with_zigzag("res://src/LevelSelect/LevelSelect.tscn")
