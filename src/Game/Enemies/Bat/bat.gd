class_name Bat extends Enemy

@onready var player_ray_2: RayCast2D = $PlayerRay2

var is_chasing: bool = false
var movement_tween: Tween
var initial_pos: Vector2
var ray2_collider: Node

func _ready() -> void:
	initial_pos = global_position
	animated_sprite_2d.play("hang")

func kill() -> void:
	if movement_tween != null:
		movement_tween.pause()

	super()

func move(delta: float) -> void:
	if player_ray.is_colliding():
		var collider: Node = player_ray.get_collider() as Node
		if ray_collider != collider:
			if collider.is_in_group("Player"):
				player_tracked.emit()
			else:
				if ray_collider != null and ray_collider.is_in_group("Player"):
					player_tracked_stopped.emit()

			ray_collider = collider
	elif player_ray_2.is_colliding():
		var collider: Node = player_ray_2.get_collider() as Node
		if ray2_collider != collider:
			if collider.is_in_group("Player"):
				player_tracked.emit()
			else:
				if ray2_collider != null and ray2_collider.is_in_group("Player"):
					player_tracked_stopped.emit()

			ray2_collider = collider
	else:
		ray_collider = null
		ray2_collider = null
		player_tracked_stopped.emit()

func collision_check(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if Globals.player.is_immune:
			player_hit.emit(false)
			kill()
			return

		if Globals.player.velocity.y == 0:
			player_hit.emit(true)
		else:
			if Globals.player.feet_pos.global_position.y >= top_pos.global_position.y:
				player_hit.emit(true)
			else:
				player_hit.emit(false)
				kill()

func _on_player_tracked() -> void:
	if not is_chasing:
		is_chasing = true

		var desired_pos: Vector2 = Vector2(Globals.player.global_position.x, Globals.player.global_position.y)
		var fly_time: float = clampf((desired_pos.y - initial_pos.y)/2000, 0.5, 1)
		animated_sprite_2d.play("fly")

		movement_tween = get_tree().create_tween()
		movement_tween.tween_property(self, "global_position", desired_pos, fly_time)
		movement_tween.tween_property(self, "global_position", desired_pos, 0.5)
		movement_tween.tween_property(self, "global_position", initial_pos, fly_time)
		movement_tween.tween_callback(
			func() -> void:
				is_chasing = false
				animated_sprite_2d.play("hang")
				movement_tween.kill()
		)
