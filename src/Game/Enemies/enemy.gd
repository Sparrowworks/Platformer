class_name Enemy extends CharacterBody2D

signal player_hit()

@export var speed: float = 500.0
@export var chase_speed: float = 750.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var left_ray: RayCast2D = $LeftRay
@onready var right_ray: RayCast2D = $RightRay
@onready var player_ray: RayCast2D = $PlayerRay

var direction: Vector2 = Vector2.LEFT

func _physics_process(delta: float) -> void:
	pass

func _kill() -> void:
	pass
