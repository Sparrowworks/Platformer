class_name Enemy extends Area2D

signal player_hit(is_hurt: bool)

@export var speed: float = 500.0
@export var chase_speed: float = 750.0
@export var does_chase: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var left_ray: RayCast2D = $LeftRay
@onready var right_ray: RayCast2D = $RightRay
@onready var player_ray: RayCast2D = $PlayerRay

var direction: Vector2 = Vector2.LEFT
var actual_speed: float = speed

func move(delta: float) -> void:
	if not left_ray.is_colliding():
		direction = Vector2.RIGHT
		animated_sprite_2d.flip_h = true

	if not right_ray.is_colliding():
		direction = Vector2.LEFT
		animated_sprite_2d.flip_h = false

	if does_chase:
		if player_ray.is_colliding():
			var collider: Node = player_ray.get_collider() as Node
			if collider.is_in_group("Player"):
				actual_speed = chase_speed
				animated_sprite_2d.speed_scale = 2
			else:
				actual_speed = speed
				animated_sprite_2d.speed_scale = 1
		else:
			actual_speed = speed
			animated_sprite_2d.speed_scale = 1

func kill() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	set_physics_process(false)

	animation_player.play("Kill")
	await animation_player.animation_finished

	queue_free()

func _physics_process(delta: float) -> void:
	move(delta)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player: Player = body as Player
		if player.velocity.y == 0:
			player_hit.emit(true)
		else:
			player_hit.emit(false)
			kill()
	else:
		if direction == Vector2.RIGHT:
			direction = Vector2.LEFT
			animated_sprite_2d.flip_h = false
		else:
			direction = Vector2.RIGHT
			animated_sprite_2d.flip_h = true
