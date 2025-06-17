extends Control

@onready var title: Label = $Title
@onready var help: Label = $Help

var page_switch: Tween
var is_switching: bool = false
var page: int = 0

var headings: Array[String] = [
	"In-Game Controls: ",
	"Story: ",
	"In-Game Credits: ",
]
var content: Array[String] = [
	"""use wasd or arrow keys to walk\npress space to jump\npress q in game to go back to menu
	\npress r to quickly restart the level\npress enter to proceed to the next level""",

	"""You are an alien who has been travelling space with a spaceship. Unfortunately, a collision with an asteroid forced you to land on earth and catapult yourself. now you have to find your vehicle to get back home.""",

	"""coding: Sp4r0w & VargaDot\nart & Blocks font: kenney\nWatermelon Days font: Khurasan
	\nButton sprites: Viktor Gogela\nMusic: joshuuu (alt OST: Clustertruck OST)""",
]

func _ready() -> void:
	title.text = headings[page]
	help.text = content[page]

func _on_switch_button_pressed() -> void:
	if is_switching:
		return

	is_switching = true
	page_switch = get_tree().create_tween()
	page_switch.set_trans(Tween.TransitionType.TRANS_ELASTIC)
	page_switch.set_ease(Tween.EASE_IN_OUT)

	page_switch.tween_property(help, "position:x", 4000, 1)
	page_switch.tween_callback(_on_page_switch)

	page_switch.tween_property(help, "position:x", 485.5, 1)
	page_switch.tween_callback(_on_switch_done)

func _on_page_switch() -> void:
	page = (page + 1) % 3
	title.text = headings[page]
	help.text = content[page]

	help.position.x = -4000

func _on_switch_done() -> void:
	is_switching = false
	page_switch.kill()

func _on_back_button_pressed() -> void:
	if is_switching:
		return

	Globals.go_to_with_zigzag("res://src/MainMenu/MainMenu.tscn")
