class_name Spinner extends CharacterBody2D

signal player_tracked
signal player_tracked_stopped
signal player_hit(is_hurt: bool)

@export var speed: float = 300.0
@export var chase_speed: float = 600.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var player_ray: RayCast2D = $PlayerRay
@onready var wall_ray: RayCast2D = $WallRay

var jump_height: float = 5.5
var gravity: float = 20.0

var direction: Vector2 = Vector2.LEFT
var actual_speed: float = speed
var ray_collider: Node


func _ready() -> void:
	animated_sprite_2d.play("spin")


func turn_right() -> void:
	player_ray.rotation = deg_to_rad(180)
	wall_ray.rotation = deg_to_rad(180)
	direction = Vector2.RIGHT
	animated_sprite_2d.flip_h = true


func turn_left() -> void:
	player_ray.rotation = deg_to_rad(0)
	wall_ray.rotation = deg_to_rad(0)
	direction = Vector2.LEFT
	animated_sprite_2d.flip_h = false


func move(delta: float) -> void:
	# Change the direction of the enemy if reached a wall
	if wall_ray.is_colliding():
		var collider: Node = wall_ray.get_collider() as Node2D
		if not collider.is_in_group("Player"):
			if direction == Vector2.RIGHT:
				turn_left()
			else:
				turn_right()

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

	velocity.x = direction.x * actual_speed
	velocity.y += gravity

	move_and_slide()


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
		else:
			player_hit.emit(true)


# Make the spinner jump with the player when its tracking them
func _physics_process(delta: float) -> void:
	if ray_collider != null:
		if ray_collider.is_in_group("Player"):
			if Input.is_action_just_pressed("jump"):
				velocity.y = -((jump_height * 10.0) * gravity)

	move(delta)


# Speeden up the spinner if its tracking the player
func _on_player_tracked() -> void:
	actual_speed = chase_speed
	animated_sprite_2d.speed_scale = 2


func _on_player_tracked_stopped() -> void:
	actual_speed = speed
	animated_sprite_2d.speed_scale = 1


func _on_hit_box_body_entered(body: Node2D) -> void:
	collision_check(body)
