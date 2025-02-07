class_name ZigZag extends CanvasLayer

signal finished_moving()

@onready var control: Control = $Control

var zigzag_tween: Tween

func _ready() -> void:
	control.setup_zigzag()
	move_to_center()

	Composer.finished_loading.connect(_on_finished_loading)

func move_to_center() -> void:
	zigzag_tween = get_tree().create_tween()
	zigzag_tween.set_trans(Tween.TRANS_QUAD)
	zigzag_tween.tween_property(control,"global_position:x",0,0.75)
	zigzag_tween.tween_callback(
		func() -> void:
			zigzag_tween.kill()
			finished_moving.emit()
	)

func move_to_back() -> void:
	control.global_position = Vector2(0, 0)

	zigzag_tween = get_tree().create_tween()
	zigzag_tween.set_trans(Tween.TRANS_QUAD)
	zigzag_tween.tween_property(control,"global_position:x",control.width,0.75)
	zigzag_tween.tween_callback(
		func() -> void:
			zigzag_tween.kill()
			Composer.clear_load_screen()
	)

func _on_finished_loading(_scene: Node) -> void:
	move_to_back()
