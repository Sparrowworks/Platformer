extends Control

@onready var desc: Label = $VBoxContainer/Desc
@onready var scores: Label = $VBoxContainer/Scores

func _ready() -> void:
	if Globals.is_new_game:
		desc.text = ""
		scores.text = "Game stats:\n\nTotal time: " + str(Globals.total_time) + "\nTotal score: " + str(Globals.total_score) + "\nTotal Deaths: " + str(Globals.total_deaths) + "\nTotal Kills: " + str(Globals.total_kills)
	else:
		desc.text = "You have completed level " + str(Globals.level)
		scores.text = "Level stats:\n\nTotal time: " + str(Globals.total_time) + "\nTotal score: " + str(Globals.total_score) + "\nTotal Deaths: " + str(Globals.total_deaths) + "\nTotal Kills: " + str(Globals.total_kills)


func _on_menu_button_pressed() -> void:
	Globals.go_to_with_zigzag("res://src/MainMenu/MainMenu.tscn")
