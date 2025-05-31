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
	# Change the direction of the enemy if trying to move off a platform or a cliff
	if not left_ray.is_colliding():
		turn_right()

	if not right_ray.is_colliding():
		turn_left()

	# Code for player raycast used to check if an enemy spotted the player
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

func collision_check(area: Area2D) -> void:
	if area.is_in_group("Player"):
		# Kill the enemy by default if a player has immunity
		if Globals.player.is_immune:
			player_hit.emit(false)
			kill()
			return

		# If a player isn't jumping, hurt them
		if Globals.player.velocity.y == 0:
			player_hit.emit(true)
		else:
			# If a player's position is higher than the enemy's, kill the enemy, else hurt the player
			if Globals.player.feet_pos.global_position.y >= top_pos.global_position.y:
				player_hit.emit(true)
			else:
				if not Globals.player.is_hurt:
					player_hit.emit(false)
					kill()

func _physics_process(delta: float) -> void:
	move(delta)

func _on_area_entered(area: Area2D) -> void:
	collision_check(area)

func _on_body_entered(body: Node2D) -> void:
	# Change the direction if an enemy hit something (that is not the player)
	if not body.is_in_group("Player"):
		if direction == Vector2.RIGHT:
			turn_left()
		else:
			turn_right()
