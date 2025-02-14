extends Control

@onready var ost_title: Label = %OstTitle
@onready var speedrun_title: Label = %SpeedrunTitle

@onready var master_title: Label = %MasterTitle
@onready var master_slider: HSlider = %MasterSlider

@onready var music_title: Label = %MusicTitle
@onready var music_slider: HSlider = %MusicSlider

@onready var sfx_title: Label = %SfxTitle
@onready var sfx_slider: HSlider = %SfxSlider

func _ready() -> void:
	_update_buttons()
	_update_sliders()

func _update_buttons() -> void:
	if Globals.is_alternative_ost:
		ost_title.text = "Alternative ost: on"
	else:
		ost_title.text = "Alternative ost: off"

	if Globals.is_speedrun_mode:
		speedrun_title.text = "Speedrun mode: on"
	else:
		speedrun_title.text = "Speedrun mode: off"

func _update_sliders() -> void:
	master_title.text = "master volume: " + str(Globals.master_volume)
	master_slider.value = Globals.master_volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Globals.master_volume/100))

	music_title.text = "music volume: " + str(Globals.music_volume)
	music_slider.value = Globals.music_volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(Globals.music_volume/100))

	sfx_title.text = "sfx volume: " + str(Globals.sfx_volume)
	sfx_slider.value = Globals.sfx_volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(Globals.sfx_volume/100))

func _on_ost_button_pressed() -> void:
	Globals.button_click.play()
	Globals.is_alternative_ost = !Globals.is_alternative_ost
	_update_buttons()

func _on_mode_button_pressed() -> void:
	Globals.button_click.play()
	Globals.is_speedrun_mode = !Globals.is_speedrun_mode
	_update_buttons()

func _on_master_slider_value_changed(value: float) -> void:
	Globals.master_volume = value
	_update_sliders()

func _on_music_slider_value_changed(value: float) -> void:
	Globals.music_volume = value
	_update_sliders()

func _on_sfx_slider_value_changed(value: float) -> void:
	Globals.sfx_volume = value
	_update_sliders()

func _on_back_button_pressed() -> void:
	Globals.go_to_with_zigzag("res://src/MainMenu/MainMenu.tscn")
