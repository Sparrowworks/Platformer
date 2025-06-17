class_name UI extends Control

@onready var dead_text: Label = $DeadText
@onready var dead_animation: AnimationPlayer = $DeadText/DeadAnimation

@onready var end_text_container: VBoxContainer = %EndTextContainer
@onready var end_text: Label = %EndText
@onready var prompt: Label = %Prompt
@onready var prompt_animation: AnimationPlayer = %PromptAnimation

@onready var score_text: Label = $TopBar/HBoxContainer/ScoreText
@onready var coin_text: Label = $TopBar/HBoxContainer/CoinText
@onready var health_text: Label = $TopBar/HBoxContainer/HealthText
@onready var level_text: Label = $TopBar/HBoxContainer/LevelText
@onready var time_text: Label = $TopBar/HBoxContainer/TimeText

@onready var score_anim: AnimationPlayer = %ScoreAnim
@onready var coin_anim: AnimationPlayer = %CoinAnim
@onready var health_anim: AnimationPlayer = %HealthAnim


func _ready() -> void:
	dead_animation.play("RESET")
	prompt_animation.play("RESET")
	dead_text.hide()
	end_text.hide()


func set_color_white() -> void:
	dead_text.add_theme_color_override("font_color", Color.WHITE)
	end_text.add_theme_color_override("font_color", Color.WHITE)
	prompt.add_theme_color_override("font_color", Color.WHITE)


func play_score_anim(animation: String) -> void:
	if score_anim.is_playing() and score_anim.current_animation == animation:
		score_anim.play(animation)
	else:
		score_anim.play("RESET")
		score_anim.play(animation)


func play_coin_anim(animation: String) -> void:
	if coin_anim.is_playing() and coin_anim.current_animation == animation:
		coin_anim.play(animation)
	else:
		coin_anim.play("RESET")
		coin_anim.play(animation)


func play_health_anim(animation: String) -> void:
	if health_anim.is_playing() and health_anim.current_animation == animation:
		health_anim.play(animation)
	else:
		health_anim.play("RESET")
		health_anim.play(animation)


func _on_player_update_ui(score: int, coins: int, health: int, level: int, time: int) -> void:
	score_text.text = "Score: " + str(score)
	coin_text.text = "Coins: " + str(coins)

	health_text.text = "Health: " + str(health)
	if health <= 1:
		health_text.modulate = Color.RED
	else:
		health_text.modulate = Color.WHITE

	level_text.text = "Level: " + str(level)
	time_text.text = "Time: " + str(time)
	if time <= 30:
		time_text.modulate = Color.RED
	else:
		time_text.modulate = Color.WHITE


func _on_player_player_dead() -> void:
	dead_text.show()
	dead_animation.play("Blink")


func _on_game_end() -> void:
	end_text_container.show()
	prompt_animation.play("Blink")
