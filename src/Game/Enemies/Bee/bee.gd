class_name Bee extends Enemy

var time: float
var is_chasing: bool = false
var movement_tween: Tween

func _ready() -> void:
	animated_sprite_2d.play("fly")

func turn_right() -> void:
	direction = Vector2.RIGHT
	animated_sprite_2d.flip_h = true
	player_ray.rotation = deg_to_rad(-224)

func turn_left() -> void:
	direction = Vector2.LEFT
	animated_sprite_2d.flip_h = false
	player_ray.rotation = deg_to_rad(225)

func move(delta: float) -> void:
	if not is_chasing:
		super(delta)

		time += delta
		global_position += Vector2(direction.x, sin(time*3)) * actual_speed * delta

func kill() -> void:
	if movement_tween != null:
		movement_tween.pause()

	super()

func _on_player_tracked() -> void:
	if not is_chasing:
		is_chasing = true

		var initial_pos: Vector2 = global_position
		var desired_pos: Vector2 = Vector2(Globals.player.global_position.x, Globals.player.global_position.y)
		var time: float = clampf((desired_pos.y - initial_pos.y)/2000, 0.5, 1)

		movement_tween = get_tree().create_tween()
		movement_tween.tween_property(self, "global_position", desired_pos, time)
		movement_tween.tween_callback(
			func() -> void:
				await get_tree().create_timer(0.5)
		)
		movement_tween.tween_property(self, "global_position", initial_pos, time)
		movement_tween.tween_callback(
			func() -> void:
				is_chasing = false
				movement_tween.kill()
		)
