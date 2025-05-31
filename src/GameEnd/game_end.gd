extends Control

@onready var desc: Label = %Desc
@onready var title: Label = %Title
@onready var time_text: Label = %TimeText
@onready var score_text: Label = %ScoreText
@onready var deaths_text: Label = %DeathsText
@onready var enemies_text: Label = %EnemiesText

func _ready() -> void:
	if Globals.is_new_game:
		desc.text = "Congratulations!
		You have managed to find the lost ufo ship and now you can return to your home planet!"

		title.text = "Game Stats:"

		if Globals.is_speedrun_mode:
			time_text.text = "Total Time: " + str(Globals.level_speedrun_times[6])
		else:
			time_text.text = "Total Time: " + str(Globals.total_time)

		score_text.text = "Total Score: " + str(Globals.total_score)
		deaths_text.text = "Total Deaths: " + str(Globals.total_deaths)
		enemies_text.text = "Total Kills: " + str(Globals.total_kills)
	else:
		desc.text = "You have completed level " + str(Globals.level)
		title.text = "Level Stats:"

		if Globals.is_speedrun_mode:
			time_text.text = "Total Time: " + str(Globals.level_speedrun_times[Globals.level])
		else:
			time_text.text = "Total Time: " + str(Globals.total_time)

		score_text.text = "Total Score: " + str(Globals.total_score)
		deaths_text.text = "Total Deaths: " + str(Globals.total_deaths)
		enemies_text.text = "Total Kills: " + str(Globals.total_kills)

	$GameOver.play()

func _on_menu_button_pressed() -> void:
	Globals.go_to_with_zigzag("res://src/MainMenu/MainMenu.tscn")
