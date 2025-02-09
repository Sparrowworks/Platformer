class_name Spider extends Enemy

func _ready() -> void:
	animated_sprite_2d.play("walk")

func move(delta: float) -> void:
	super(delta)

	global_position += direction * actual_speed * delta

func kill() -> void:
	animated_sprite_2d.play("dead")
	super()


func _on_player_tracked() -> void:
	actual_speed = chase_speed
	animated_sprite_2d.speed_scale = 2


func _on_player_tracked_stopped() -> void:
	actual_speed = speed
	animated_sprite_2d.speed_scale = 1
