class_name Enemy extends Area2D

signal player_tracked()
signal player_tracked_stopped()
signal player_hit(is_hurt: bool)

@export var speed: float = 500.0
@export var chase_speed: float = 750.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var top_pos: Marker2D = $TopPos

@onready var left_ray: RayCast2D = $LeftRay
@onready var right_ray: RayCast2D = $RightRay
@onready var player_ray: RayCast2D = $PlayerRay

var direction: Vector2 = Vector2.LEFT
var actual_speed: float = speed
var ray_collider: Node

func turn_right() -> void:
	direction = Vector2.RIGHT
	animated_sprite_2d.flip_h = true
	player_ray.rotation = deg_to_rad(180)

func turn_left() -> void:
	direction = Vector2.LEFT
	animated_sprite_2d.flip_h = false
	player_ray.rotation = deg_to_rad(0)

func move(delta: float) -> void:
	if not left_ray.is_colliding():
		turn_right()

	if not right_ray.is_colliding():
		turn_left()

	if player_ray.is_colliding():
		var collider: Node = player_ray.get_collider() as Node
		if ray_collider != collider:
			if collider.is_in_group("Player"):
				player_tracked.emit()
			else:
				if ray_collider != null and ray_collider.is_in_group("Player"):
					player_tracked_stopped.emit()

			ray_collider = collider
	else:
		ray_collider = null
		player_tracked_stopped.emit()

func kill() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	set_physics_process(false)

	animation_player.play("Kill")
	await animation_player.animation_finished

	queue_free()

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
	elif not body.is_in_group("Enemy") or not body.is_in_group("Pickup"):
		if direction == Vector2.RIGHT:
			turn_left()
		else:
			turn_right()

func _physics_process(delta: float) -> void:
	move(delta)

func _on_body_entered(body: Node2D) -> void:
	collision_check(body)
